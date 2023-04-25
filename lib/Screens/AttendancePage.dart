import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nester/Model/model.dart';
import 'package:nester/Screens/ScannerPage.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../providers/AttendenceProvider.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage();

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    final checkedIn = Provider.of<AttendanceService>(context).checkedIn;
    final checkedOut = Provider.of<AttendanceService>(context).checkedOut;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!checkedIn)
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ScannerPage(
                                        ischeckin: true,
                                      )));
                        },
                        child: const Text('Check In'),
                      ),
                    if (!checkedOut)
                      ElevatedButton(
                        onPressed: () async {
                          if (checkedIn) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const ScannerPage(
                                          ischeckin: false,
                                        )));
                          } else {
                            errortoast('Cannot Checkout before Checking In');
                          }
                        },
                        child: const Text('Check Out'),
                      ),
                  ],
                ),
                if (checkedIn && checkedOut)
                  const Center(
                      child: Text(
                          'You have already checked in and checked out today.')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
