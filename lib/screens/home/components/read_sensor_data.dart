import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lbpalert/constants.dart';
import 'package:lbpalert/services/api.dart';
import 'package:lbpalert/services/auth.dart';
import '../../../size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/models/notif_item.dart';
import 'package:lbpalert/screens/home/components/section_title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ReadSensorData extends StatefulWidget {
  final int painTarget;
  final String deviceID;
  ReadSensorData(this.painTarget, this.deviceID);

  @override
  _ReadSensorDataState createState() => _ReadSensorDataState();
}

class _ReadSensorDataState extends State<ReadSensorData> {
  String? apiData;
  String? predictiveText;
  String? dateTimestamp;
  String? today;
  bool showPrediction = false;
  bool hasPastPredictions = false;
  Color? currentColor = Colors.grey;
  Color? predictiveColor;
  int? cnt;
  int? total;
  Map<String, dynamic> predictionItems = {};
  final AuthService _auth = AuthService();
  final months = MONTHS;
  final days = DAYS_SHORT;

  @override
  void initState() {
    super.initState();
    checkPastPredictions();
    activatePrediction();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });
    // App in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
      }
    });
    // App in background but still running and user taps on the notification
    // from the device tray
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  void activatePrediction() async {
    final List<List<double>> sensorReadings = [];
    late StreamSubscription sensorDataStreamSubscription;

    final DatabaseReference _sensorRef =
        FirebaseDatabase.instance.ref("Sensor_Data/${widget.deviceID}");

    Stream<DatabaseEvent> sensorDataStream = _sensorRef.onValue;

    sensorDataStreamSubscription =
        sensorDataStream.listen((DatabaseEvent event) async {
      final sensor00 =
          (event.snapshot.value as dynamic)["sEMG00"]["voltage_Level"];
      final sensor01 =
          (event.snapshot.value as dynamic)["sEMG01"]["voltage_Level"];
      final sensor10 =
          (event.snapshot.value as dynamic)["sEMG10"]["voltage_Level"];
      final sensor11 =
          (event.snapshot.value as dynamic)["sEMG11"]["voltage_Level"];

      sensorReadings.add([sensor00, sensor01, sensor10, sensor11]);

      print(sensorReadings.length);

      if (sensorReadings.length == 5) {
        sensorDataStreamSubscription.pause();
        final json = sensorReadings.toString();
        await makePostRequest(json).then(
          (prediction) async {
            setState(() {
              apiData = prediction;
            });
            showPrediction = true;
            if (int.parse(apiData!) > widget.painTarget) {
              notifications.insert(
                  0,
                  Item(
                    color: Colors.red,
                    title: "Above Target",
                    description: "Warning! You are above your target",
                  ));
            }
            getTimestamp();
            getPredictionInfo(prediction);
            updateNotifications();
            calculateDailyAverage(prediction);
            sensorReadings.removeAt(0);
            await Future.delayed(Duration(seconds: 5));
          },
        );
        sensorDataStreamSubscription.resume();
      }
    });
  }

  void getTimestamp() {
    final List<String> timestamp = DateTime.now().toString().split(" ");

    final List<String> dateStamp = timestamp[0].split("-");
    final List<String> timeStamp = timestamp[1].split(":");

    final String date = dateStamp[1] + "-" + dateStamp[2] + "-" + dateStamp[0];
    final String time = timeStamp[0] + ":" + timeStamp[1];

    setState(() {
      dateTimestamp = date + " " + time;
      today = date;
    });
  }

  void getPredictionInfo(prediction) {
    if (int.parse(prediction) >= 0 && int.parse(prediction) <= 5) {
      setState(() {
        predictiveColor = Colors.green;
        predictiveText = "No strain";
      });
    } else if (int.parse(prediction) > 5 && int.parse(prediction) <= 8) {
      setState(() {
        predictiveColor = Colors.orange;
        predictiveText = "More strain";
      });
    } else {
      setState(() {
        predictiveColor = Colors.red;
        predictiveText = "WARNING";
      });
    }
  }

  void updateNotifications() {
    if (currentColor != predictiveColor) {
      if (predictiveColor == Colors.green) {
        notifications.insert(
            0,
            Item(
              color: Colors.green,
              title: "Green Alert",
              description: "You are in a safe zone",
            ));
      } else if (predictiveColor == Colors.orange) {
        notifications.insert(
            0,
            Item(
              color: Colors.orange,
              title: "Orange Alert",
              description: "Might want to relax soon",
            ));
      } else if (predictiveColor == Colors.red) {
        notifications.insert(
            0,
            Item(
              color: Colors.red,
              title: "Red Alert",
              description: "Warning! You are at risk",
            ));
      }
    }
    currentColor = predictiveColor;
  }

  void checkPastPredictions() async {
    final uid = _auth.getUserID;
    final DatabaseReference _aveRef =
        FirebaseDatabase.instance.ref("users/$uid/daily_averages");
    final _aveRefSnap = await _aveRef.get();
    if (_aveRefSnap.children.isNotEmpty) {
      hasPastPredictions = true;
      if (_aveRefSnap.exists) {
        predictionItems = jsonDecode(jsonEncode((_aveRefSnap.value)));
      }
    }
  }

  void calculateDailyAverage(prediction) async {
    int value = int.parse(prediction);
    final uid = _auth.getUserID;
    final DatabaseReference _userRef =
        FirebaseDatabase.instance.ref("users/$uid");
    final _userSnap = await _userRef.get();
    if (_userSnap.hasChild("daily_averages")) {
      print("it has averages");
      final _dateRef = _userRef.child("daily_averages/$today");
      final _dateSnap = await _dateRef.get();
      // print(_aveSnap.value);
      if (_dateSnap.exists) {
        print("it has today's date");
        cnt = (_dateSnap.value as dynamic)["daily_averages"][today]["count"];
        total = (_dateSnap.value as dynamic)["daily_averages"][today]["total"];
        cnt = (cnt! + 1);
        total = (total! + value);
        _dateRef.update({
          "count": cnt,
          "total": total,
          "average": (total! / cnt!).floor(),
        });
        checkPastPredictions();
      } else {
        print("today isnt available");
        final _dateRef = _userRef.child("daily_averages/$today");
        _dateRef.set({
          "count": 1,
          "total": value,
          "average": value,
        });
        checkPastPredictions();
      }
    } else {
      print("no daily averages");
      final _dateRef = _userRef.child("daily_averages/$today");
      _dateRef.set({
        "count": 1,
        "total": value,
        "average": value,
      });
      checkPastPredictions();
    }
  }

  @override
  Widget build(BuildContext context) {
    var finalList = [];
    var trendList = predictionItems.entries.toList();
    trendList.sort((b, a) => a.key.compareTo(b.key));
    for (int i = 0; i < trendList.length; i++) {
      var date = trendList[i].key.split("-");
      var day = date[2] + "-" + date[0] + "-" + date[1] + " 00:00:00.000";
      var t = DateTime.parse(day);
      finalList.add((days[t.weekday] +
          ', ' +
          months[t.month - 1] +
          ' ' +
          t.day.toString()));
    }

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          margin: EdgeInsets.only(
              top: getProportionateScreenWidth(5),
              bottom: getProportionateScreenWidth(5)),
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(15),
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 63, 62, 62),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Back Health",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.normal,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(1),
                    ),
                    child: Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: showPrediction ? apiData! + " : " : "",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(20),
                                  fontWeight: FontWeight.bold,
                                  color: predictiveColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: showPrediction
                                    ? predictiveText
                                    : "No activity",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(20),
                                  fontWeight: FontWeight.normal,
                                  color: showPrediction
                                      ? predictiveColor
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Text.rich(
                    TextSpan(
                      text: showPrediction ? dateTimestamp : "",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.normal,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: CircleAvatar(
                  radius: getProportionateScreenWidth(85),
                  backgroundColor:
                      showPrediction ? predictiveColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(30)),
        SectionTitle(title: 'Summary'),
        SizedBox(height: getProportionateScreenWidth(10)),
        Container(
          height: 180,
          child: hasPastPredictions
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: trendList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: getProportionateScreenWidth(5),
                          bottom: getProportionateScreenWidth(5)),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 63, 62, 62),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.scale,
                          color: kPrimaryColor,
                        ),
                        title: Text(
                          finalList[index], //trendList[index].key,
                          style: TextStyle(color: kPrimaryColor, fontSize: 17),
                        ),
                        trailing: Text(
                            predictionItems[trendList[index].key]["average"]
                                .toString(),
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 22,
                            )),
                      ),
                    );
                  })
              : Column(
                  children: [
                    SizedBox(height: getProportionateScreenWidth(30)),
                    Text("No Past Predictions",
                        style: TextStyle(color: kPrimaryColor, fontSize: 17)),
                  ],
                ),
        )
      ],
    );
  }
}
