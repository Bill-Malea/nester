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
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  tileColor: grievance.response == null
                      ? Colors.amberAccent
                      : Colors.greenAccent,
                  title: Text(
                    grievance.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(grievance.description),
                      const SizedBox(
                        height: 5,
                      ),
                      grievance.response != null
                          ? Text(
                              ' ${grievance.response}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  onTap: () => _showGrievanceDialog(grievance.response ?? ''),
                ),
              );
            },
          );
  }
}
