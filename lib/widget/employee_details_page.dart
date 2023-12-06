import 'package:flutter/material.dart';
import 'package:flutter_with_spring_boot/model/employee.dart';
import 'package:flutter_with_spring_boot/modal/update_employee_modal.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailsPage({super.key, required this.employee});

  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late Employee _employee;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Details'),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            _showUpdateEmployeeModal(context, _employee);
          },
        ),
      ],
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        children: [
          buildEmployeeImage(),
          buildEmployeeDetailText('Name', _employee.name, 20, FontWeight.bold),
          buildEmployeeDetailText('Job Title', _employee.jobTitle, 18),
          buildEmployeeDetailText('Email', _employee.email, 16),
          buildEmployeeDetailText('Phone', _employee.phone, 16),
        ],
      ),
    );
  }

  Widget buildEmployeeImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Image.network(
        _employee.imageUrl,
        width: 100.0,
        height: 100.0,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildEmployeeDetailText(String label, String value, double fontSize, [FontWeight? fontWeight]) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        value,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }

  Future<void> _showUpdateEmployeeModal(BuildContext context, Employee employee) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return UpdateEmployeeModal(
          onEmployeeUpdated: (updatedEmployee) {
            print('Employee updated: ${updatedEmployee.name}');
            _handleEmployeeUpdate(updatedEmployee);
          },
          existingEmployee: employee,
        );
      },
    );
  }

  void _handleEmployeeUpdate(Employee updatedEmployee) {
    setState(() {
      _employee = updatedEmployee;
    });
  }
}
