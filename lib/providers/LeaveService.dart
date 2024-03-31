import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nester/Model/model.dart';

class LeaveService extends ChangeNotifier {
  final id = FirebaseAuth.instance.currentUser!.uid;
  final String apiUrl =
      "https://employee-management-syst-29f9f-default-rtdb.firebaseio.com";

  Future<List<Leave>> fetchLeaves() async {
    final response = await http.get(Uri.parse('$apiUrl/Leave/$id.json'));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200 && data != null) {
      final jsonList = data as Map<String, dynamic>;
      List<Leave> leaves = [];
      jsonList.forEach((key, value) {
        leaves.add(Leave.fromJson(value));
      });

      return leaves;
    } else {
      throw Exception('No applied leaves Yet');
    }
  }

  Future<bool> applyLeave(DateTime from, DateTime to, String reason) async {
    final url = Uri.parse('$apiUrl/Leave/$id.json');
    final response = await http.post(
      url,
      body: json.encode({
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
        'reason': reason,
        'supportDoc':
            'https://files.jotform.com/jotformapps/request-for-leave-6318d6094ebf84f0c1be89c44cfc41ad-classic.png'
      }),
    );
    if (response.statusCode != 200) {
      errortoast('Couldnt Send A Leave Request Try Again Later');
      return false;
    }
    return response.statusCode == 200;
  }
}
