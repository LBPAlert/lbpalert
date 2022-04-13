import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TrendsChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;

  TrendsChart(this.seriesList, {this.animate = false});

  /// Creates a time series chart with sample data and no transition.
  factory TrendsChart.withSampleData() {
    return new TrendsChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
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
      primaryMeasureAxis: new charts.NumericAxisSpec(
        viewport: charts.NumericExtents(0, 10),
      ),
      behaviors: [
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        new charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        new charts.PanAndZoomBehavior(),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<BackData, DateTime>> _createSampleData() {
    final data = [
      new BackData(DateTime(2019, 1, 7), 5),
      new BackData(DateTime(2019, 1, 8), 3),
      new BackData(DateTime(2019, 1, 9), 6),
      new BackData(DateTime(2019, 1, 10), 7),
      new BackData(DateTime(2019, 1, 11), 5),
      new BackData(DateTime(2019, 1, 12), 2),
      new BackData(DateTime(2019, 1, 13), 10),
      new BackData(DateTime(2019, 1, 14), 7),
      new BackData(DateTime(2019, 1, 15), 8),
      new BackData(DateTime(2019, 1, 16), 6),
    ];

    return [
      new charts.Series<BackData, DateTime>(
        id: '',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BackData back, _) => back.day,
        measureFn: (BackData back, _) => back.backData,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class BackData {
  final DateTime day;
  final int backData;

  BackData(this.day, this.backData);
}
