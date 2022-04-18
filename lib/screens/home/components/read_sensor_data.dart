import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lbpalert/constants.dart';
import 'package:lbpalert/services/api.dart';
import 'package:lbpalert/services/auth.dart';
import 'package:lbpalert/services/database.dart';
import '../../../size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/models/notif_item.dart';

class ReadSensorData extends StatefulWidget {
  @override
  _ReadSensorDataState createState() => _ReadSensorDataState();
}

class _ReadSensorDataState extends State<ReadSensorData> {
  String? apiData;
  Color? predictiveColor;
  String? predictiveText;
  String? dateTimestamp;
  bool showPrediction = false;
  Color? currentColor = Colors.grey;
  bool isChanged = false;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    activateListeners();
    // getAPIPrediction();
    // getDatabasePrediction();
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
          (prediction) {
            setState(() {
              apiData = prediction;
            });
            showPrediction = true;
            getPredictiveColor(prediction);
            getPredictiveText(prediction);
            getTimestamp();
            sensorReadings.removeAt(0);
          },
        );
        sensorDataStreamSubscription.resume();
      }
    });
  }

  void getAPIPrediction() {
    final uid = _auth.getUserID;
    final PredictionDatabaseService _prediction =
        PredictionDatabaseService(uid: uid);
    _prediction.getMLPredictions();
  }

  void getDatabasePrediction() {
    final uid = _auth.getUserID;
    final UserDatabaseService _users = UserDatabaseService(uid: uid);

    DatabaseReference user = _users.getUser;

    DatabaseReference prediction = user.child("prediction");

    prediction.onChildAdded.listen((event) {
      print(event.snapshot.value);
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

  void getTimestamp() {
    final List<String> timestamp = DateTime.now().toString().split(" ");

    final List<String> dateStamp = timestamp[0].split("-");
    final List<String> timeStamp = timestamp[1].split(":");

    final String date = dateStamp[1] + "/" + dateStamp[2] + "/" + dateStamp[0];
    final String time = timeStamp[0] + ":" + timeStamp[1];

    setState(() {
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
            description: "Warning! You are at risk of lower back pain",
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                          text: showPrediction ? predictiveText : "No activity",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.normal,
                            color:
                                showPrediction ? predictiveColor : Colors.grey,
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
            backgroundColor: showPrediction ? predictiveColor : Colors.grey,
          ),
        ),
      ]),
    );
  }

  // @override
  // void deactivate() {
  //   // dailyStream.cancel();
  //   super.deactivate();
  // }
}
