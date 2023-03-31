import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/model.dart';

class AttendanceService extends ChangeNotifier {
  final id = FirebaseAuth.instance.currentUser!.uid;
  List<AttendanceData> _attendancedata = [];
  List<AttendanceData> get attendancedata => [..._attendancedata];
  bool _checkedIn = false;
  bool get checkedIn => _checkedIn;
  bool _checkedOut = false;
  bool get checkedOut => _checkedOut;
  String date() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString();
    final day = now.day.toString();
    return year + month + day;
  }

  final apiUrl = 'https://nester-fee8e-default-rtdb.firebaseio.com';
  Future<void> checkIn() async {
    final datetoday = date();
    final now = DateTime.now().toIso8601String();

    final body = json.encode({
      'checkin': now,
    });
    final response = await http
        .patch(Uri.parse('$apiUrl/Attendance/$id/$datetoday.json'), body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to check in.');
    } else if (response.statusCode == 200) {
      await fetchcheckIn();
    }
  }

  Future<String?> fetchcheckIn() async {
    final datetoday = date();
    final now = DateTime.now().toIso8601String();

    final body = json.encode({
      'checkin': now,
    });
    final response = await http.get(
      Uri.parse('$apiUrl/Attendance/$id/$datetoday/checkin.json'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to check in.');
    }
    var data = jsonDecode(response.body);
    print(data);
    _checkedIn = data == null ? false : true;
    notifyListeners();
    return data;
  }

  Future<String?> fetchcheckOut() async {
    final datetoday = date();
    final now = DateTime.now().toIso8601String();

    final response = await http.get(
      Uri.parse('$apiUrl/Attendance/$id/$datetoday/checkout.json'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to check in.');
    }
    var data = jsonDecode(response.body);

    _checkedOut = data == null ? false : true;
    notifyListeners();
    return data;
  }

  Future<void> checkOut() async {
    final datetoday = date();
    final now = DateTime.now().toIso8601String();
    var checkin = await fetchcheckIn();

    final body = json.encode({
      'checkout': now,
      'checkin': checkin,
      'date': DateTime.now().toIso8601String(),
    });
    final response = await http
        .put(Uri.parse('$apiUrl/Attendance/$id/$datetoday.json'), body: body);
    if (response.statusCode != 200) {
      throw Exception('Failed to check out.');
    } else if (response.statusCode == 200) {
      await fetchcheckOut();
    }
  }

  Future<List<AttendanceData>> fetchAttendance() async {
    final response = await http.get(Uri.parse('$apiUrl/Attendance/$id.json'));

    List<AttendanceData> rawdata = [];
    final jsonList = jsonDecode(response.body);
    if (response.statusCode == 200 && jsonList != null) {
      final data = jsonList as Map<String, dynamic>;

      data.forEach((key, value) {
        rawdata.add(AttendanceData.fromJson(value));
      });
      _attendancedata = rawdata;
      notifyListeners();
      return rawdata;
    } else {
      throw Exception('Failed to fetch attendance');
    }
  }
}
