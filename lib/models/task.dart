import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String projectId;
  String name;
  String assignedTo;
  String priority;
  DateTime startDate;
  DateTime endDate;
  String status;
  String comments;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.name,
    required this.assignedTo,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.comments,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      name: data['name'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      priority: data['priority'] ?? 'Media',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? 'Por hacer',
      comments: data['comments'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'name': name,
      'assignedTo': assignedTo,
      'priority': priority,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'comments': comments,
    };
  }
}
