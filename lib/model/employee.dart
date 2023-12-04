class Employee {
  final int id;
  final String name;
  final String email;
  final String jobTitle;
  final String phone;
  final String imageUrl;
  final String? employeeCode;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.phone,
    required this.imageUrl,
    this.employeeCode,
  });

  factory Employee.fromJson(Map<String, dynamic> json){
    return Employee(id: json['id'],
      name: json['name'],
      email: json['email'],
      jobTitle: json['jobTitle'],
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      employeeCode: json['employeeCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'jobTitle': jobTitle,
      'phone': phone,
      'imageUrl': imageUrl,
      'employeeCode': employeeCode,
    };
  }
}