import 'package:flutter/material.dart';
import 'package:nester/providers/LeaveService.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';

class LeavesPage extends StatelessWidget {
  const LeavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    String tittle(bool? status) {
      if (status == null) {
        return 'Pending';
      } else if (status == true) {
        return 'Approved';
      }
      return 'Denied';
    }

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
                } else if (leave.status == true) {
                  backgroundColor = Colors.greenAccent;
                } else if (leave.status == false) {
                  backgroundColor = Colors.redAccent;
                }
                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text(leave.reason),
                    subtitle: Text(tittle(leave.status)),
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
