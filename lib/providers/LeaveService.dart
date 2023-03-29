import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nester/Model/model.dart';

class LeaveService extends ChangeNotifier {
  final id = FirebaseAuth.instance.currentUser!.uid;
  final String apiUrl = "https://nester-fee8e-default-rtdb.firebaseio.com";
  final faker = Faker();
  Future<List<Leave>> fetchLeaves() async {
    final response = await http.get(Uri.parse('$apiUrl/Leave/$id.json'));

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as Map<String, dynamic>;
      List<Leave> leaves = [];
      jsonList.forEach((key, value) {
        leaves.add(Leave.fromJson(value));
      });

      return leaves;
    } else {
      throw Exception('Failed to fetch leaves');
    }
  }

  Future<bool> applyLeave(
      String type, DateTime from, DateTime to, String reason) async {
    final url = Uri.parse('$apiUrl/Leave/$id.json');
    final response = await http.post(
      url,
      body: json.encode({
        'type': type,
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        'reason': reason
      }),
    );
    return response.statusCode == 200;
  }
}
