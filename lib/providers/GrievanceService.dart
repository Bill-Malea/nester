import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/Grievance.dart';

class GrievanceService extends ChangeNotifier {
  final String apiUrl = "https://nester-fee8e-default-rtdb.firebaseio.com";
  final id = FirebaseAuth.instance.currentUser!.uid;
  List<Grievance> _grievances = [];
  List<Grievance> get grievances => [..._grievances];
  Future<bool> submitGrievance({
    required String title,
    required String department,
    required String description,
  }) async {
    final url = Uri.parse('$apiUrl/Grievances/$id.json');
    final response = await http.post(
      url,
      body: json.encode({
        'title': title,
        'department': department,
        'description': description,
        'response': null
      }),
    );
    return response.statusCode == 200;
  }

  Future<void> fetchGrievances() async {
    final url = Uri.parse('$apiUrl/Grievances/$id.json');
    final response = await http.get(
      url,
    );

    final rawdata = jsonDecode(response.body);
    List<Grievance> rawgrievances = [];
    if (response.statusCode == 200 && rawdata != null) {
      final data = rawdata as Map<String, dynamic>;

      data.forEach((key, value) {
        
        rawgrievances.add(Grievance.fromJson(value));
      });
      _grievances = rawgrievances;
      notifyListeners();
    }
  }
}
