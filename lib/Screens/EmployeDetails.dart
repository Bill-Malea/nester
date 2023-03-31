import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';
import '../providers/EmployeProvider.dart';

class EmployDetails extends StatelessWidget {
  const EmployDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: FutureBuilder<Employee?>(
        future: Provider.of<EmployeeService>(context).getEmployeeById(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final employee = snapshot.data!;
          print(employee.department);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: Text(employee.name),
                subtitle: Text(employee.email),
                trailing: Text(employee.phone),
              ),
              const SizedBox(height: 16.0),
              Text('ID: ${employee.id}'),
              const SizedBox(height: 8.0),
              Text('Department: ${employee.department}'),
              const SizedBox(height: 8.0),
              Text('Manager: ${employee.gender}'),
              const SizedBox(height: 8.0),
              Text('Salary: ${employee.salary}'),
              const SizedBox(height: 8.0),
              Text('Join Date: ${employee.joineDate}'),
            ],
          );
        },
      ),
    );
  }
}
