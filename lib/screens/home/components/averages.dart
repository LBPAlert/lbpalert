import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:firebase_database/firebase_database.dart';

class Averages extends StatefulWidget {
  @override
  _AveragesState createState() => _AveragesState();
}

class _AveragesState extends State<Averages> {
  String sensorData = "Insert Data Here";

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
      setState(() {
        sensorData = '${event.snapshot.value}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.only(
              top: getProportionateScreenWidth(5),
              bottom: getProportionateScreenWidth(5)),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 63, 62, 62),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Icon(
              Icons.nordic_walking,
              color: kPrimaryColor,
            ),
            title: Text(
              "Daily Average",
              style: TextStyle(color: kPrimaryColor),
            ),
            trailing: Text(
              sensorData,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.only(
              top: getProportionateScreenWidth(5),
              bottom: getProportionateScreenWidth(5)),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 63, 62, 62),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Icon(
              Icons.nordic_walking,
              color: kPrimaryColor,
            ),
            title: Text(
              "Weekly Average",
              style: TextStyle(color: kPrimaryColor),
            ),
            trailing: Text(
              sensorData,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.only(
              top: getProportionateScreenWidth(5),
              bottom: getProportionateScreenWidth(5)),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 63, 62, 62),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Icon(
              Icons.nordic_walking,
              color: kPrimaryColor,
            ),
            title: Text(
              "Monthly Average",
              style: TextStyle(color: kPrimaryColor),
            ),
            trailing: Text(
              sensorData,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
