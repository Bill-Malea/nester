import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResignService extends ChangeNotifier {
  final String apiUrl = 'https://your-api-url.com';

  Future<void> submitResignation(String reason) async {
    try {
      final response = await http
          .post(Uri.parse('$apiUrl/resignation'), body: {'reason': reason});

      if (response.statusCode != 200) {
        throw Exception('Failed to submit resignation.');
      }
    } catch (e) {
      throw Exception('Failed to submit resignation: ${e.toString()}');
    }
  }
}
