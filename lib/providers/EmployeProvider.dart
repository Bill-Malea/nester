import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/model.dart';
import 'package:http/http.dart' as http;

class EmployeeService extends ChangeNotifier {
  final String apiUrl = "https://example.com/api/employees";
  final id = FirebaseAuth.instance.currentUser!.uid;

  Future<Employee> getEmployeeById() async {
    var data = {
      'id': '120200',
      'name': 'John Doe',
      'email': 'Johndoe@gmail.com',
      'phone': '0720000233',
      'department': 'Finance',
      'gender': 'Male',
      'joineDate': DateTime.now().toIso8601String(),
      'salary': '60,000',
    };
    notifyListeners();
    return Employee.fromJson(data);

    //   final response = await http.get(Uri.parse('$apiUrl/$id'));
    //   if (response.statusCode == 200) {
    //     final data = json.decode(response.body);
    //     return Employee.fromJson(data);
    //   } else {
    //     throw Exception('Failed to load employee');
    //   }
  }
}
