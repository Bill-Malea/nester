import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/GrievanceService.dart';

class VoiceGrievancePage extends StatefulWidget {
  @override
  _VoiceGrievancePageState createState() => _VoiceGrievancePageState();
}

class _VoiceGrievancePageState extends State<VoiceGrievancePage> {
  final _formKey = GlobalKey<FormState>();
  var _title = '';
  var _department = '';
  var _text = '';

  bool _isLoading = false;

  Future<void> _submitGrievance() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });

      form.save();

      try {
        await Provider.of<GrievanceService>(context, listen: false)
            .submitGrievance(
          title: _title,
          department: _department,
          description: _text,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Grievance submitted successfully'),
        ));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error submitting grievance'),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a department';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _department = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Grievance'),
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your grievance';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _text = value!;
                  },
                ),
                SizedBox(height: 16.0),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: _submitGrievance,
                        child: Text('Submit Grievance'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
