import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String id;
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  String responsible;
  String status;
  String priority;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.responsible,
    required this.status,
    required this.priority,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      responsible: json['responsible'],
      status: json['status'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'responsible': responsible,
      'status': status,
      'priority': priority,
    };
  }
}