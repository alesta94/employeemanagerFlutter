// create a new file, e.g., add_employee_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_spring_boot/model/employee.dart';
import 'package:flutter_with_spring_boot/services/employee_service.dart';
import 'package:image_picker/image_picker.dart';

class AddEmployeeModal extends StatefulWidget {
  final Function(Employee) onEmployeeAdded;

  const AddEmployeeModal({Key? key, required this.onEmployeeAdded}) : super(key: key);

  @override
  _AddEmployeeModalState createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends State<AddEmployeeModal> {
  final EmployeeService employeeService = EmployeeService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextInputFormatter phoneFormatter = FilteringTextInputFormatter.digitsOnly;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneFormatter],
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              GestureDetector(
                onTap: () async {
                  await _showImageUrlDialog(context);
                },
                child: TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Employee newEmployee = Employee(
                    id: 1,
                    name: nameController.text,
                    email: emailController.text,
                    jobTitle: jobTitleController.text,
                    phone: phoneController.text,
                    imageUrl: imageUrlController.text,
                  );

                  try {
                    Employee addedEmployee = await employeeService.addEmployee(newEmployee);
                    widget.onEmployeeAdded(addedEmployee);

                    setState(() {});
                  } catch (e) {
                    print('Error adding employee: $e');
                  }

                  Navigator.pop(context);
                },
                child: Text("SAVE"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImageUrlDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Image"),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String? imageUrl = await _getImageUrlDialog(context);
                  if (imageUrl != null) {
                    imageUrlController.text = imageUrl;
                  }
                },
                child: Text("Add from URL"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    imageUrlController.text = pickedImage.path;
                  }
                },
                child: Text("Pick from Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _getImageUrlDialog(BuildContext context) async {
    TextEditingController imageUrlController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Image from URL'),
          content: TextField(
            controller: imageUrlController,
            decoration: InputDecoration(labelText: 'Image URL'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String imageUrl = imageUrlController.text;
                Navigator.pop(context, imageUrl);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
