import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  String id;
  String name;
  String description;
  String status;
  String assignedTo;
  DateTime startDate;
  DateTime endDate;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.startDate,
    required this.endDate,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'Por Hacer',
      assignedTo: data['assignedTo'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'assignedTo': assignedTo,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
    };
  }
}
