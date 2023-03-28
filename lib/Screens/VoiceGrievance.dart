import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceGrievancePage extends StatefulWidget {
  @override
  _VoiceGrievancePageState createState() => _VoiceGrievancePageState();
}

class _VoiceGrievancePageState extends State<VoiceGrievancePage> {
  String _grievance = '';
  String _voiceFilePath = '';
  bool _isRecording = false;
  var record = Record();
  void _startRecording() async {
    bool hasPermission = await _getPermission();
    if (hasPermission) {
      setState(() {
        _isRecording = true;
      });

      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/voice_grievance.wav';

      await record.start(path: filePath);

      setState(() {
        _voiceFilePath = filePath;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please grant microphone permission.'),
        ),
      );
    }
  }

  void _stopRecording() async {
    setState(() {
      _isRecording = false;
    });

    await record.stop();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice recording saved.'),
      ),
    );
  }

  Future<bool> _getPermission() async {
    PermissionStatus status = await Permission.microphone.request();

    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _submitGrievance() async {
    // Implement the logic to send the user's grievance and the recorded voice file to the server using an API request
    // Use the _grievance and _voiceFilePath variables to get the data to send to the server
    // Use an API service to upload the recorded voice file to the server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Grievance'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter your grievance',
                ),
                onChanged: (value) {
                  setState(() {
                    _grievance = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitGrievance,
                    child: const Text('Submit Grievance'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(_voiceFilePath),
            ],
          ),
        ),
      ),
    );
  }
}
