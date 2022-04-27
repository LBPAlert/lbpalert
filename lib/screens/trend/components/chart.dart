import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lbpalert/services/auth.dart';

class TrendsChart extends StatefulWidget {
  // final List<charts.Series<BackData, DateTime>> seriesList;
  // final bool animate;

  // TrendsChart(this.seriesList, {this.animate = false});

  /// Creates a time series chart with sample data and no transition.
  // factory TrendsChart.withSampleData() {
  //   _TrendsChartState();
  //   return TrendsChart(
  //     // _createSampleData(),
  //     someList,
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  @override
  _TrendsChartState createState() => _TrendsChartState();

  /// Create one series with sample hard coded data.
  // static List<charts.Series<BackData, DateTime>> _createSampleData() {
  //   final data = [
  //     BackData(DateTime.now().subtract(Duration(days: 9)), 5),
  //     BackData(DateTime.now().subtract(Duration(days: 8)), 3),
  //     BackData(DateTime.now().subtract(Duration(days: 7)), 6),
  //     BackData(DateTime.now().subtract(Duration(days: 6)), 7),
  //     BackData(DateTime.now().subtract(Duration(days: 5)), 5),
  //     BackData(DateTime.now().subtract(Duration(days: 4)), 2),
  //     BackData(DateTime.now().subtract(Duration(days: 3)), 10),
  //     BackData(DateTime.now().subtract(Duration(days: 2)), 7),
  //     BackData(DateTime.now().subtract(Duration(days: 1)), 8),
  //     BackData(DateTime.now(), 6),
  //   ];

  //   return [
  //     charts.Series<BackData, DateTime>(
  //       id: '',
  //       colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
  //       domainFn: (BackData back, _) => back.day,
  //       measureFn: (BackData back, _) => back.backData,
  //       data: data,
  //     )
  //   ];
  // }
}

class _TrendsChartState extends State<TrendsChart> {
  bool hasPastPredictions = false;
  Map<String, dynamic> predictionItems = {};
  List<charts.Series<dynamic, DateTime>> newList = [];

  @override
  void initState() {
    super.initState();
    checkPastPredictions();
  }

  void checkPastPredictions() async {
    final AuthService _auth = AuthService();
    final uid = _auth.getUserID;
    final DatabaseReference _aveRef =
        FirebaseDatabase.instance.ref("users/$uid/daily_averages");
    final _aveRefSnap = await _aveRef.get();
    if (_aveRefSnap.children.isNotEmpty) {
      // hasPastPredictions = true;
      getPastPredictions(_aveRefSnap);
    }
  }

  void getPastPredictions(aveRefSnap) async {
    if (aveRefSnap.exists) {
      predictionItems = jsonDecode(jsonEncode((aveRefSnap.value)));

      newList = _createTrends(predictionItems);
    }
  }

  List<charts.Series<BackData, DateTime>> _createTrends(
      Map<String, dynamic> predictionItems) {
    var someList = predictionItems.entries.toList();
    someList.sort((a, b) => a.key.compareTo(b.key));

    final List<BackData> trendsData = [];

    for (int i = 0; i < someList.length; i++) {
      var date = someList[i].key.split("-");
      var day = date[2] + "-" + date[0] + "-" + date[1] + " 00:00:00.000";
      trendsData
          .add(BackData(DateTime.parse(day), someList[i].value["average"]));
    }

    return [
      charts.Series<BackData, DateTime>(
        id: '',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (BackData back, _) => back.day,
        measureFn: (BackData back, _) => back.backData,
        data: trendsData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      newList,
      animate: false,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
            labelStyle:
                charts.TextStyleSpec(color: charts.MaterialPalette.white)),
        viewport: charts.DateTimeExtents(
            start: DateTime.now().subtract(Duration(days: 4)),
            end: DateTime.now()),
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'EEE',
            transitionFormat: 'EEE',
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
          viewport: charts.NumericExtents(0, 10),
          renderSpec: charts.GridlineRendererSpec(
              labelStyle:
                  charts.TextStyleSpec(color: charts.MaterialPalette.white))),
      behaviors: [
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        charts.PanAndZoomBehavior(),
      ],
    );
  }
}

/// Sample ordinal data type.
class BackData {
  final DateTime day;
  final int backData;

  BackData(this.day, this.backData);
}
