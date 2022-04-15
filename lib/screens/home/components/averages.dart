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

  Map<String, int> items = {
    'Mon': 3,
    'Thurs': 4,
    'Sat': 6,
    'Wed': 7,
    'Sun': 10
  };

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
    var trendList = items.entries.toList();

    return Container(
      height: 180,
      child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: items.length,
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
                  trendList[index].key,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                trailing: Text(items[trendList[index].key].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    )),
              ),
            );
          }),
    );
  }
}
