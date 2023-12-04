// employee_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_with_spring_boot/model/employee.dart';
import 'package:flutter_with_spring_boot/services/employee_service.dart';
import 'package:flutter_with_spring_boot/widget/employee_details.dart';
import 'package:flutter_with_spring_boot/modal/add_employee_modal.dart';
import 'package:flutter_with_spring_boot/widget/employee_details_page.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final EmployeeService employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddEmployeeModal(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: employeeService.getAllEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Employee> employees = snapshot.data as List<Employee>;
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToEmployeeDetailsPage(employees[index]);
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(employees[index]);
                  },
                  child: EmployeeDetailsWidget(employee: employees[index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToEmployeeDetailsPage(Employee employee) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailsPage(employee: employee),
      ),
    );
    setState(() {});
  }

  void _showAddEmployeeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddEmployeeModal(
          onEmployeeAdded: (employee) {
            print('Employee added: ${employee.name}');
            setState(() {});
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${employee.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteEmployee(employee);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEmployee(Employee employee) async {
    try {
      await employeeService.deleteEmployee(employee.id);
      print('Employee deleted: ${employee.name}');
      setState(() {});
    } catch (e) {
      print('Error deleting employee: $e');
    }
  }
}
