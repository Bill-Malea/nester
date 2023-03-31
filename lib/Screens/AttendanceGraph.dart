import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nester/providers/AttendenceProvider.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';

// ignore: must_be_immutable
class AttendanceGraph extends StatefulWidget {
  AttendanceGraph({super.key});

  @override
  State<AttendanceGraph> createState() => _AttendanceGraphState();
}

class _AttendanceGraphState extends State<AttendanceGraph> {
  @override
  void initState() {
    Provider.of<AttendanceService>(context, listen: false).fetchAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AttendanceData> data =
        Provider.of<AttendanceService>(context).attendancedata;
    List<charts.Series<AttendanceData, DateTime>> seriesList = [
      charts.Series<AttendanceData, DateTime>(
        id: 'Attendance',
        colorFn: (_, __) => charts.MaterialPalette.black.lighter,
        domainFn: (AttendanceData attendance, _) => attendance.date,
        measureFn: (AttendanceData attendance, _) => attendance.timeDifference,
        data: data,
      )
    ];

    return data.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 200),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          )
        : Center(
            child: SizedBox(
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
            ),
          );
  }
}
