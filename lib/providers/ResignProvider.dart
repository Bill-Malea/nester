import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResignService extends ChangeNotifier {
  final id = FirebaseAuth.instance.currentUser!.uid;
  final String apiUrl = 'https://nester-fee8e-default-rtdb.firebaseio.com/';
  String _resignstatus = '';

  String get resignstatus => _resignstatus;
  Future<void> submitResignation(String reason) async {
    try {
      final response =
          await http.post(Uri.parse('$apiUrl/Resignation/$id.json'), body: {
        'reason': reason,
        'status': 'pending',
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to submit resignation.');
      }
    } catch (e) {
      throw Exception('Failed to submit resignation: ${e.toString()}');
    }
  }

  Future<String> fetchResignationStatus() async {
    final response = await http.get(Uri.parse('$apiUrl/Resignation/$id.json'));
    final data = json.decode(response.body);
    _resignstatus = data;
    notifyListeners();
    return data['status'];
  }
}
