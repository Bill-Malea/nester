import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GrievanceService extends ChangeNotifier {
  final String apiUrl = "https://nester-fee8e-default-rtdb.firebaseio.com";

  Future<bool> submitGrievance({
    required String title,
    required String department,
    required String description,
  }) async {
    final url = Uri.parse('$apiUrl/Grievances.json');
    final response = await http.post(
      url,
      body: json.encode({
        'title': title,
        'department': department,
        'description': description
      }),
    );
    return response.statusCode == 200;
  }
}
