import 'package:flutter/material.dart';
import 'package:flutter_with_spring_boot/widget/employee_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EmployeeListScreen(),
    );
  }
}