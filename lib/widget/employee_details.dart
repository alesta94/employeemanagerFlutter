import 'package:flutter/material.dart';
import 'package:flutter_with_spring_boot/model/employee.dart';

class EmployeeDetailsWidget extends StatelessWidget {
  final Employee employee;

  EmployeeDetailsWidget({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text('Email: ${employee.email}'),
                Text('Job Title: ${employee.jobTitle}'),
                Text('Phone: ${employee.phone}'),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Image.network(
              employee.imageUrl,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
