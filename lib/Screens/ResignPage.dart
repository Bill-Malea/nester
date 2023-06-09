import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ResignProvider.dart';

class ResignPage extends StatefulWidget {
  const ResignPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResignPageState createState() => _ResignPageState();
}

class _ResignPageState extends State<ResignPage> {
  final _reasonController = TextEditingController();
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resign'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reason for Resignation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reasonController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Enter reason for resignation',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a reason for resignation';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            isloading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final reason = _reasonController.text.trim();

                      if (reason.isNotEmpty) {
                        setState(() {
                          isloading = true;
                        });
                        await Provider.of<ResignService>(context, listen: false)
                            .submitResignation(reason, context)
                            .whenComplete(() {
                          setState(() {
                            isloading = false;
                          });
                        });
                      }
                    },
                    child: const Text('Submit Resignation'),
                  ),
          ],
        ),
      ),
    );
  }
}
