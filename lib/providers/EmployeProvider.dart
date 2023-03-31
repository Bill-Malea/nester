import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Model/model.dart';
import 'package:http/http.dart' as http;

class EmployeeService extends ChangeNotifier {
  final String apiUrl = "https://nester-fee8e-default-rtdb.firebaseio.com";
  final id = FirebaseAuth.instance.currentUser!.uid;

  Future<Employee?> getEmployeeById() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/Employees/$id.json'));
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data != null) {
        final json = data as Map<String, dynamic>;

        for (var elem in json.values) {
          print(elem);
          return Employee.fromJson(elem);
        }
      } else {
        return null;
      }
    } catch (e) {}
    return null;
  }
}
