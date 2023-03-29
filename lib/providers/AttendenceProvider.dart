import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/model.dart';

class AttendanceService extends ChangeNotifier {
  List<DateTime> _checkIns = [];
  List<DateTime> _checkOuts = [];
  String _currentQRCode = '';

  List<DateTime> get checkIns => _checkIns;
  List<DateTime> get checkOuts => _checkOuts;

  final apiUrl = '';
  Future<void> checkIn(DateTime dateTime) async {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final body = json.encode({
      'timestamp': timestamp,
      'dateTime': dateTime.toIso8601String(),
      'type': 'checkIn',
    });
    final response = await http.post(Uri.parse(apiUrl), body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to check in.');
    }
  }

  Future<void> checkOut(DateTime dateTime) async {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final body = json.encode({
      'timestamp': timestamp,
      'dateTime': dateTime.toIso8601String(),
      'type': 'checkOut',
    });
    final response = await http.post(Uri.parse(apiUrl), body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to check out.');
    }
  }

  Future<List<AttendanceData>> fetchAttendance() async {
    final response =
        await http.get(Uri.parse('https://example.com/api/attendance'));
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => AttendanceData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch attendance');
    }
  }
}
