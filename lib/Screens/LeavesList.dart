import 'package:flutter/material.dart';
import 'package:nester/providers/LeaveService.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';

class LeavesPage extends StatelessWidget {
  const LeavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<List<Leave>>(
        future: Provider.of<LeaveService>(context).fetchLeaves(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.only(top: 200),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final leaves = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: leaves!.length,
              itemBuilder: (context, index) {
                final leave = leaves[index];
                Color? backgroundColor;
                if (leave.status == null) {
                  backgroundColor = Colors.amber;
                } else if (leave.status!.toLowerCase() == 'Approved') {
                  backgroundColor = Colors.greenAccent;
                } else if (leave.status!.toLowerCase() == 'Denied') {
                  backgroundColor = Colors.redAccent;
                }
                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text(leave.reason),
                    subtitle: Text(leave.status ?? 'Pending'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      // ignore: todo
                      // TODO: Navigate to leave details page
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    ]);
  }
}
