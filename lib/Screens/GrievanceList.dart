import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/Grievance.dart';
import '../providers/GrievanceService.dart';

class GrievancesList extends StatefulWidget {
  const GrievancesList({Key? key}) : super(key: key);

  @override
  _GrievancesListState createState() => _GrievancesListState();
}

class _GrievancesListState extends State<GrievancesList> {
  @override
  void initState() {
    Provider.of<GrievanceService>(context, listen: false).fetchGrievances();
    super.initState();
  }

  void _showGrievanceDialog(
    String message,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Grievance Message'),
          content: Text(message.isEmpty ? 'No Response from HR ' : message),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Grievance> grievances =
        Provider.of<GrievanceService>(context).grievances;
    return grievances.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 200),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: grievances.length,
            itemBuilder: (context, index) {
              final grievance = grievances[index];
              return ListTile(
                tileColor: grievance.response == null
                    ? Colors.greenAccent
                    : Colors.redAccent,
                title: Text(grievance.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(grievance.description),
                    const SizedBox(
                      height: 10,
                    ),
                    grievance.response != null
                        ? Text(' ${grievance.description}')
                        : const SizedBox(),
                  ],
                ),
                onTap: () => _showGrievanceDialog(grievance.response ?? ''),
              );
            },
          );
  }
}
