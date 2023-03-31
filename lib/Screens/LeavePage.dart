import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nester/providers/LeaveService.dart';
import 'package:provider/provider.dart';

class LeavePage extends StatefulWidget {
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _formKey = GlobalKey<FormState>();

  var _reason = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  var _supportingDocumentPath = '';

  Future<void> _pickSupportingDocument() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _supportingDocumentPath = pickedFile!.path;
    });
  }

  var _isloading = false;

  final List<String> _leaveReasons = [
    'Vacation',
    'Sick leave',
    'Maternity leave',
    'Paternity leave',
    'Bereavement leave',
    'Personal leave',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Application'),
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Reason for leave',
                        border: OutlineInputBorder(),
                      ),
                      items: _leaveReasons
                          .map((reason) => DropdownMenuItem(
                                value: reason,
                                child: Text(reason),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a reason for your leave';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _reason = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(
                          'Start date: ${_startDate.toLocal().toString().split(' ')[0]}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _startDate = selectedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(
                          'End date: ${_endDate.toLocal().toString().split(' ')[0]}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _endDate = selectedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Supporting document'),
                      subtitle: Text(_supportingDocumentPath),
                      trailing: const Icon(Icons.attach_file),
                      onTap: () async {
                        await _pickSupportingDocument();
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isloading = true;
                          });
                          Provider.of<LeaveService>(context, listen: false)
                              .applyLeave(_startDate, _endDate, _reason)
                              .then((value) {
                            setState(() {
                              _isloading = false;
                            });
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Leave application submitted'),
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
