import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lbpalert/constants.dart';
import 'package:lbpalert/services/api.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import '../../../size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/models/notif_item.dart';
import 'package:lbpalert/screens/home/components/section_title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ReadSensorData extends StatefulWidget {
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
  bool isChanged = false;
  Color? currentColor = Colors.grey;
  Color? predictiveColor;
  int? cnt;
  int? total;
  int? painTarget;
  Map<String, dynamic> predictionItems = {};

  @override
  void initState() {
    super.initState();
    // activateListeners();
    // checkPastPredictions();
    // randomIntegerGenerator();
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

  void checkPastPredictions() async {
    final AuthService _auth = AuthService();
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

  void randomIntegerGenerator() async {
    var rng = Random();
    for (var i = 0; i < 50; i++) {
      if (i < 10) {
        setState(() {
          apiData = rng.nextInt(11).toString();
          today = "04-24-2022";
        });
      } else if (i >= 10 && i < 20) {
        setState(() {
          apiData = rng.nextInt(11).toString();
          today = "04-25-2022";
        });
      } else if (i >= 20 && i < 30) {
        setState(() {
          apiData = rng.nextInt(11).toString();
          today = "04-26-2022";
        });
      } else if (i >= 30 && i < 40) {
        setState(() {
          apiData = rng.nextInt(11).toString();
          today = "04-27-2022";
        });
      } else if (i >= 40 && i < 50) {
        setState(() {
          apiData = rng.nextInt(11).toString();
          today = "04-28-2022";
        });
      }
      showPrediction = true;
      getUserTarget();
      getTimestamp();
      calculateDailyAverage(apiData);
      getPredictiveColor(apiData);
      getPredictiveText(apiData);
      checkForChange();
      updateNotifications();
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void calculateDailyAverage(prediction) async {
    int value = int.parse(prediction);

    final AuthService _auth = AuthService();
    final uid = _auth.getUserID;
    final DatabaseReference _aveRef =
        FirebaseDatabase.instance.ref("users/$uid/daily_averages");
    final _aveRefSnap = await _aveRef.get();
    final _aveSnap = await _aveRef.child(today!).get();

    if (_aveSnap.exists) {
      final DatabaseReference _dateRef =
          FirebaseDatabase.instance.ref("users/$uid/daily_averages/$today");
      final _aveData = await _dateRef.get();
      if (_aveData.exists) {
        cnt = (_aveData.value as dynamic)["count"];
        total = (_aveData.value as dynamic)["total"];
        cnt = (cnt! + 1);
        total = (total! + value);
        _dateRef.update({
          "count": cnt,
          "total": total,
          "average": (total! / cnt!).floor(),
        });
      }
    } else {
      checkPastPredictions();
      final DatabaseReference _dateRef =
          FirebaseDatabase.instance.ref("users/$uid/daily_averages/$today");
      _dateRef.update({
        "count": 1,
        "total": value,
        "average": value,
      });
    }
  }

  void activateListeners() {
    final List<List<double>> sensorReadings = [];
    late StreamSubscription sensorDataStreamSubscription;

    final DatabaseReference _sensorRef =
        FirebaseDatabase.instance.ref("Sensor_Data");

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

      if (sensorReadings.length == 500) {
        sensorDataStreamSubscription.pause();
        final json = sensorReadings.toString();
        await makePostRequest(json).then(
          (prediction) async {
            setState(() {
              apiData = prediction;
            });
            showPrediction = true;
            getUserTarget();
            getTimestamp();
            getPredictiveColor(prediction);
            getPredictiveText(prediction);
            checkForChange();
            updateNotifications();
            sensorReadings.removeAt(0);
            await Future.delayed(Duration(seconds: 5));
          },
        );
        sensorDataStreamSubscription.resume();
      }
    });
  }

  void getPredictiveColor(prediction) {
    if (int.parse(prediction) >= 0 && int.parse(prediction) <= 5) {
      setState(() {
        predictiveColor = Colors.green;
      });
    } else if (int.parse(prediction) > 5 && int.parse(prediction) <= 8) {
      setState(() {
        predictiveColor = Colors.orange;
      });
    } else {
      setState(() {
        predictiveColor = Colors.red;
      });
    }
  }

  void getPredictiveText(prediction) {
    if (int.parse(prediction) >= 0 && int.parse(prediction) <= 5) {
      setState(() {
        predictiveText = "No strain";
      });
    } else if (int.parse(prediction) > 5 && int.parse(prediction) <= 8) {
      setState(() {
        predictiveText = "More strain";
      });
    } else {
      setState(() {
        predictiveText = "WARNING";
      });
    }
  }

  void getUserTarget() async {
    final AuthService _auth = AuthService();
    final uid = _auth.getUserID;
    final UserDatabaseService _users = UserDatabaseService(uid);

    DatabaseReference child = _users.getUser;
    final userData = await child.get();
    if (userData.exists) {
      setState(() {
        painTarget = (userData.value as dynamic)["pain_target"];
      });
      if (int.parse(apiData!) > painTarget!) {
        notifications.insert(
            0,
            Item(
              color: Colors.red,
              title: "Above Target",
              description: "Warning! You are above your target",
            ));
      }
    }
  }

  void getTimestamp() {
    final List<String> timestamp = DateTime.now().toString().split(" ");

    final List<String> dateStamp = timestamp[0].split("-");
    final List<String> timeStamp = timestamp[1].split(":");

    final String date = dateStamp[1] + "-" + dateStamp[2] + "-" + dateStamp[0];
    final String time = timeStamp[0] + ":" + timeStamp[1];

    setState(() {
      // today = date;
      dateTimestamp = date + " " + time;
    });
  }

  void checkForChange() {
    if (currentColor != predictiveColor) {
      currentColor = predictiveColor;
      isChanged = true;
    } else {
      currentColor = predictiveColor;
      isChanged = false;
    }
  }

  void updateNotifications() {
    if (isChanged == true && predictiveColor == Colors.green) {
      notifications.insert(
          0,
          Item(
            color: Colors.green,
            title: "Green Alert",
            description: "You are in a safe zone",
          ));
    } else if (isChanged == true && predictiveColor == Colors.orange) {
      notifications.insert(
          0,
          Item(
            color: Colors.orange,
            title: "Orange Alert",
            description: "Might want to relax soon",
          ));
    } else if (isChanged == true && predictiveColor == Colors.red) {
      notifications.insert(
          0,
          Item(
            color: Colors.red,
            title: "Red Alert",
            description: "Warning! You are at risk",
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var finalList = [];
    final MONTHS = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC",
    ];
    final DAYS = [
      "NULL",
      "MON",
      "TUE",
      "WED",
      "THUR",
      "FRI",
      "SAT",
      "SUN",
    ];
    var trendList = predictionItems.entries.toList();
    trendList.sort((b, a) => a.key.compareTo(b.key));
    for (int i = 0; i < trendList.length; i++) {
      var date = trendList[i].key.split("-");
      var day = date[2] + "-" + date[0] + "-" + date[1] + " 00:00:00.000";
      var t = DateTime.parse(day);
      finalList.add((DAYS[t.weekday] +
          ', ' +
          MONTHS[t.month - 1] +
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

  // @override
  // void deactivate() {
  //   // dailyStream.cancel();
  //   super.deactivate();
  // }
}
