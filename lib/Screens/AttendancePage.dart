import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../providers/AttendenceProvider.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage();

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  String _qrText = '';

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    _controller!.scannedDataStream.listen((scanData) {
      setState(() {
        _qrText = scanData.code!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendanceService = Provider.of<AttendanceService>(context);

    final checkedIn = Provider.of<AttendanceService>(context).checkedIn;
    final checkedOut = Provider.of<AttendanceService>(context).checkedOut;
    print(checkedIn);
    print(checkedOut);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Column(
        children: [
          // Expanded(
          //   flex: 3,
          //   child: QRView(
          //     key: _qrKey,
          //     onQRViewCreated: _onQRViewCreated,
          //   ),
          // ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_qrText),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!checkedIn)
                      ElevatedButton(
                        onPressed: () async {
                          Provider.of<AttendanceService>(
                            context,
                            listen: false,
                          ).checkIn();
                        },
                        child: const Text('Check In'),
                      ),
                    if (!checkedOut)
                      ElevatedButton(
                        onPressed: () async {
                          Provider.of<AttendanceService>(
                            context,
                            listen: false,
                          ).checkOut();
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
