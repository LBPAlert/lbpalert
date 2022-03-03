import 'dart:async';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:lbpalert/constants.dart';
import '../../../size_config.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:vibration/vibration.dart';

// might need to change to StaefulWidget
class ReadSensorData extends StatefulWidget {
  @override
  _ReadSensorDataState createState() => _ReadSensorDataState();
}

class _ReadSensorDataState extends State<ReadSensorData> {
  String sensorData = "0";

  DatabaseReference ref = FirebaseDatabase.instance.ref('SWE_test(1)');

  @override
  void initState() {
    super.initState();
    activateListeners();
  }

  void activateListeners() {
    DatabaseReference child = ref.child("raw_value");
    Stream<DatabaseEvent> dailyStream = child.onValue;

    // Subscribe to the stream!
    dailyStream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      print('Snapshot: ${event.snapshot}'); // DataSnapshot
      print('Value: ${event.snapshot.value}');
      setState(() {
        sensorData = '${event.snapshot.value}';
      });
    });

    //   if (int.parse(sensorData) >= 8) {
    //     Vibration.vibrate(duration: 2000);
    //   }
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
            Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                    text: sensorData,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          child: CircleAvatar(
            radius: getProportionateScreenWidth(85),
            backgroundColor: Color.fromARGB(255, 9, 228, 38),
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
