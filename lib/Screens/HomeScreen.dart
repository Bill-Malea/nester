import 'package:flutter/material.dart';
import 'package:nester/Screens/AttendancePage.dart';
import 'package:nester/Screens/EmployeDetails.dart';
import 'package:nester/Screens/ResignPage.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List<String> _items = [
    'Employ Details',
    'Attendance',
    'Leave',
    'Voice Grievance',
    'Resign'
  ];

  final List<IconData> _icons = [
    Icons.person,
    Icons.calendar_today,
    Icons.local_activity,
    Icons.record_voice_over,
    Icons.cancel
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(_items.length, (index) {
        return GestureDetector(
          onTap: () {
            switch (index) {
              case 0:
                // Navigate to EmployDetails page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const EmployDetails()));
                break;
              case 1:
                // Navigate to Attendance page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AttendancePage()));

                break;
              case 2:
                // Navigate to Leave page
                break;
              case 3:
                // Navigate to TeamChat page
                break;
              case 4:
                // Navigate to VoiceGrievance page
                break;
              case 5:
                // Navigate to Resign page
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const ResignPage()));
                break;
            }
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _icons[index],
                  size: 30.0,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  _items[index],
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
