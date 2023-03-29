import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../Model/model.dart';

// ignore: must_be_immutable
class AttendanceGraph extends StatelessWidget {
  AttendanceGraph({super.key});
  List<AttendanceData> data = [
    AttendanceData(date: DateTime(2022, 2, 28), timeDifference: 8),
    AttendanceData(date: DateTime(2022, 3, 1), timeDifference: 6),
    AttendanceData(date: DateTime(2022, 3, 2), timeDifference: 7),
    AttendanceData(date: DateTime(2022, 3, 3), timeDifference: 6),
    AttendanceData(date: DateTime(2022, 3, 4), timeDifference: 8),
  ];
  @override
  Widget build(BuildContext context) {
    List<charts.Series<AttendanceData, DateTime>> seriesList = [
      charts.Series<AttendanceData, DateTime>(
        id: 'Attendance',
        colorFn: (_, __) => charts.MaterialPalette.black.lighter,
        domainFn: (AttendanceData attendance, _) => attendance.date,
        measureFn: (AttendanceData attendance, _) => attendance.timeDifference,
        data: data,
      )
    ];

    return SizedBox(
      height: 350,
      child: charts.TimeSeriesChart(
        seriesList,
        animate: true,
        defaultRenderer: charts.LineRendererConfig(
          includeArea: true,
          stacked: false,
        ),
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }
}
