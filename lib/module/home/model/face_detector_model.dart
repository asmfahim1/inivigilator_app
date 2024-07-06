import 'dart:convert';

class Descriptor {
  final String path;
  final List<double> descriptor;

  Descriptor({required this.path, required this.descriptor});

  factory Descriptor.fromJson(Map<String, dynamic> json) {
    return Descriptor(
      path: json['path'],
      descriptor: List<double>.from(json['descriptor'].map((x) => x.toDouble())),
    );
  }
}

class Employee {
  final int id;
  final String user;
  final List<Descriptor> descriptors;

  Employee({required this.id, required this.user, required this.descriptors});

  factory Employee.fromJson(Map<String, dynamic> json) {
    var list = jsonDecode(json['descriptors']) as List;
    List<Descriptor> descriptorList = list.map((i) => Descriptor.fromJson(i)).toList();

    return Employee(
      id: json['id'],
      user: json['user'],
      descriptors: descriptorList,
    );
  }
}

class ApiResponse {
  final int statusCode;
  final String message;
  final List<Employee> data;

  ApiResponse({required this.statusCode, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Employee> employeeList = list.map((i) => Employee.fromJson(i)).toList();

    return ApiResponse(
      statusCode: json['status_code'],
      message: json['message'],
      data: employeeList,
    );
  }
}