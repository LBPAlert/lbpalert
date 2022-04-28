import 'dart:convert';
import 'package:lbpalert/services/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lbpalert/constants.dart';

class TrendsScreen extends StatefulWidget {
  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  late List<_ChartData> trendsData = [];
  late List<_ChartData> data = [];
  Map<String, dynamic> predictionItems = {};
  late TooltipBehavior _tooltip;
  late ZoomPanBehavior _zoomPanBehavior;
  late SelectionBehavior _selectionBehavior;
  bool hasPastPredictions = false;
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

  @override
  void initState() {
    super.initState();
    checkPastPredictions().then((newdata) {
      setState(() {
        trendsData = newdata;
      });
    });
    _selectionBehavior = SelectionBehavior(
        // Enables the selection
        enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
      enableSelectionZooming: true,
    );
    _tooltip = TooltipBehavior(enable: true);
  }

  Future<List<_ChartData>> checkPastPredictions() async {
    final AuthService _auth = AuthService();
    final uid = _auth.getUserID;
    final DatabaseReference _aveRef =
        FirebaseDatabase.instance.ref("users/$uid/daily_averages");
    final _aveRefSnap = await _aveRef.get();
    if (_aveRefSnap.children.isNotEmpty) {
      hasPastPredictions = true;
      if (_aveRefSnap.exists) {
        predictionItems = jsonDecode(jsonEncode((_aveRefSnap.value)));
        var someList = predictionItems.entries.toList();
        someList.sort((a, b) => a.key.compareTo(b.key));

        for (int i = 0; i < someList.length; i++) {
          var date = someList[i].key.split("-");
          var day = date[2] + "-" + date[0] + "-" + date[1] + " 00:00:00.000";
          var t = DateTime.parse(day);
          trendsData
              .add(_ChartData(DAYS[t.weekday], someList[i].value["average"]));
        }
      }
    }
    return trendsData;
  }

  @override
  Widget build(BuildContext context) {
    return hasPastPredictions
        ? SfCartesianChart(
            primaryXAxis: CategoryAxis(
                autoScrollingDelta: 5,
                autoScrollingMode: AutoScrollingMode.end),
            primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 10,
                interval: 1,
                anchorRangeToVisiblePoints: false),
            tooltipBehavior: _tooltip,
            zoomPanBehavior: _zoomPanBehavior,
            series: <ChartSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                    dataSource: trendsData,
                    xValueMapper: (_ChartData trendsData, _) => trendsData.x,
                    yValueMapper: (_ChartData trendsData, _) => trendsData.y,
                    name: 'Gold',
                    color: Color.fromARGB(255, 255, 123, 0))
              ])
        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not enough activity yet to show trends',
                  style: TextStyle(color: kPrimaryColor, fontSize: 17),
                ),
              ],
            ),
          ]);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
