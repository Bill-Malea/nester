import 'package:flutter/material.dart';
import 'package:nester/providers/ResignProvider.dart';
import 'package:provider/provider.dart';

class ResignationPage extends StatefulWidget {
  const ResignationPage({super.key});

  @override
  _ResignationPageState createState() => _ResignationPageState();
}

class _ResignationPageState extends State<ResignationPage> {
  String _resignationStatus = '';

  @override
  void initState() {
    super.initState();
    Provider.of<ResignService>(context, listen: false).fetchResignationStatus();
  }

  @override
  Widget build(BuildContext context) {
    var status = Provider.of<ResignService>(context).resignstatus;
    return Column(
      children: [
        status.isEmpty
            ? const Text('You Have Not Submitted Any Resignation Requests')
            : Container(
                child: Column(
                  children: const [
                    Icon(
                      Icons.timelapse,
                      size: 35,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Pending'),
                  ],
                ),
              )
      ],
    );
  }
}
