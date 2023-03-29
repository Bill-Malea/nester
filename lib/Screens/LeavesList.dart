import 'package:flutter/material.dart';
import 'package:nester/providers/LeaveService.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';

class LeavesPage extends StatelessWidget {
  const LeavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      FutureBuilder<List<Leave>>(
        future: Provider.of<LeaveService>(context).fetchLeaves(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
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
                if (leave.status == 'Pending') {
                  backgroundColor = Colors.yellowAccent;
                } else if (leave.status == 'Approved') {
                  backgroundColor = Colors.greenAccent;
                } else if (leave.status == 'Denied') {
                  backgroundColor = Colors.redAccent;
                }
                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text(leave.type),
                    subtitle: Text(leave.status),
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
