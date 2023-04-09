import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String department;
  final String salary;
  final String role;
  final String joineDate;
  Employee({
    required this.department,
    required this.gender,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.salary,
    required this.joineDate,
  });

  factory Employee.fromJson(json) {
    return Employee(
      role: json['name'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
      gender: json['gender'] ?? '',
      joineDate: json['joinDate'] ?? '',
      salary: json['salary'] ?? '',
    );
  }
}

errortoast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class Leave {
  final String reason;
  final bool? status;
  final DateTime startDate;
  final DateTime endDate;

  Leave(
      {required this.reason,
      required this.status,
      required this.startDate,
      required this.endDate});

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      reason: json['reason'],
      status: json['status'],
      startDate: DateTime.parse(json['from']),
      endDate: DateTime.parse(json['to']),
    );
  }
}

class Attendance {
  final DateTime date;
  final DateTime signInTime;
  final DateTime signOutTime;

  Attendance(
      {required this.date,
      required this.signInTime,
      required this.signOutTime});
  factory Attendance.random() {
    final faker = Faker();
    final date = faker.date.dateTime(minYear: 2022, maxYear: 2022);
    final signInTime = DateTime(date.year, date.month, date.day,
        faker.randomGenerator.integer(4), faker.randomGenerator.integer(10));
    final signOutTime = DateTime(date.year, date.month, date.day,
        faker.randomGenerator.integer(6), faker.randomGenerator.integer(10));
    return Attendance(
        date: date, signInTime: signInTime, signOutTime: signOutTime);
  }
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      date: DateTime.parse(json['date']),
      signInTime: DateTime.parse(json['sign_in_time']),
      signOutTime: DateTime.parse(json['sign_out_time']),
    );
  }
}

class AttendanceData {
  final DateTime date;
  final int timeDifference;

  AttendanceData({required this.date, required this.timeDifference});
  factory AttendanceData.fromJson(json) {
    var rawsignout = json['checkout'];
    var rawin = json['checkin'];
    var signout = DateTime.parse(rawsignout);
    var signin = DateTime.parse(rawin);

    var difference = signout.difference(signin).inHours;

    return AttendanceData(
      date: DateTime.parse(json['date']),
      /////////// check to avoid graph distortion in the case where
      timeDifference: difference <= 0 ? 0 : difference,
    );
  }
}
