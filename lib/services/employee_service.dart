import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_with_spring_boot/environment/environment.dart';
import 'package:flutter_with_spring_boot/model/employee.dart';

class EmployeeService {
  final String _apiServerUrl = ApiConstants.baseUrl;

  Future<List<Employee>> getAllEmployees() async {
    try {
      final response = await http.get(Uri.parse('$_apiServerUrl/employee/all'));

      if (response.statusCode == 200) {
        Iterable<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((e) => Employee.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get employees - Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in getEmployees: $error');
      throw error;
    }
  }

  Future<Employee> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$_apiServerUrl/employee/add'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode == 201) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add employee');
    }
  }

  Future<Employee> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse('$_apiServerUrl/employee/update'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployee(int employeeId) async {
    final response = await http.delete(
      Uri.parse('$_apiServerUrl/employee/delete/$employeeId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }

  Future<Employee> findById(int employeeId) async {
    final response = await http.get(
      Uri.parse('$_apiServerUrl/employee/find/$employeeId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Employee employee = Employee.fromJson(data);

      return employee;
    } else {
      throw Exception('Failed to find employee');
    }
  }
}