import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'read_sensor_data.dart';

class Averages extends StatefulWidget {
  @override
  _AveragesState createState() => _AveragesState();
}

class _AveragesState extends State<Averages> {
  bool showPrediction = false;
  Map<String, int> mockItems = {};
  String? dateTimestamp;
  int dailyAverage = 0;
  int cnt = 0;

  Map<String, int> items = {
    'Mon': 3,
    'Thurs': 4,
    'Sat': 6,
    'Wed': 7,
    'Sun': 10
  };

  @override
  void initState() {
    super.initState();
    calculateDailyAverage();
  }

  void calculateDailyAverage() {
    if (mockItems.isNotEmpty) {
      showPrediction = true;
    }
    getTimestamp();
    if (mockItems.containsKey(dateTimestamp)) {
      int value = mockItems[dateTimestamp]!;
      value = ((value) / cnt).floor();
    } else {
      mockItems[dateTimestamp!] = dailyAverage;
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

  @override
  Widget build(BuildContext context) {
    var trendList = mockItems.entries.toList();

    return Container(
      height: 180,
      child: ListView.builder(
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: mockItems.length,
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
                  showPrediction ? trendList[index].key : "No past activity",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                trailing: Text(
                    showPrediction
                        ? mockItems[trendList[index].key].toString()
                        : "",
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
