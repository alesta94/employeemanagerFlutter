import 'package:flutter/material.dart';
import 'package:flutter_with_spring_boot/model/employee.dart';
import 'package:flutter_with_spring_boot/services/employee_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class UpdateEmployeeModal extends StatefulWidget {
  final Function(Employee) onEmployeeUpdated;
  final Employee existingEmployee;

  const UpdateEmployeeModal({
    Key? key,
    required this.onEmployeeUpdated,
    required this.existingEmployee,
  }) : super(key: key);

  @override
  _UpdateEmployeeModalState createState() => _UpdateEmployeeModalState();
}

class _UpdateEmployeeModalState extends State<UpdateEmployeeModal> {
  final EmployeeService employeeService = EmployeeService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextInputFormatter phoneFormatter = FilteringTextInputFormatter.digitsOnly;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.existingEmployee.name;
    emailController.text = widget.existingEmployee.email;
    jobTitleController.text = widget.existingEmployee.jobTitle;
    phoneController.text = widget.existingEmployee.phone;
    imageUrlController.text = widget.existingEmployee.imageUrl;
  }

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
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: jobTitleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneFormatter],
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showImageUrlDialog(context);
                },
                child: const Text("Add Image"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Employee updatedEmployee = Employee(
                    id: widget.existingEmployee.id,
                    name: nameController.text,
                    email: emailController.text,
                    jobTitle: jobTitleController.text,
                    phone: phoneController.text,
                    imageUrl: imageUrlController.text,
                  );

                  try {
                    Employee result = await employeeService.updateEmployee(updatedEmployee);
                    widget.onEmployeeUpdated(result);

                    setState(() {});
                  } catch (e) {
                    print('Error updating employee: $e');
                  }

                  Navigator.pop(context);
                },
                child: const Text("UPDATE"),
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
          title: const Text("Add Image"),
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
                child: const Text("Add from URL"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    imageUrlController.text = pickedImage.path;
                  }
                },
                child: const Text("Pick from Gallery"),
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
          title: const Text('Add Image from URL'),
          content: TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String imageUrl = imageUrlController.text;
                Navigator.pop(context, imageUrl);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}