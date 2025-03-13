import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String projectId;
  String name;
  String description;
  DateTime startDate;
  DateTime endDate;
  String responsible;
  String status;
  String priority;

  Task({
    required this.id,
    required this.projectId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.responsible,
    required this.status,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      projectId: json['projectId'],
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
      'projectId': projectId,
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