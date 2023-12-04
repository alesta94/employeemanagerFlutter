import 'package:flutter/material.dart';
import 'package:flutter_with_spring_boot/widget/employee_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmployeeListScreen(),
    );
  }
}