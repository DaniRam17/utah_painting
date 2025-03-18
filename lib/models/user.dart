import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String profilePic;
  List<String> assignedProjects;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.assignedProjects,
  });

  // Convertir un documento Firestore a objeto UserModel
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePic: data['profilePic'] ?? '',
      assignedProjects: List<String>.from(data['assignedProjects'] ?? []),
    );
  }

  // Convertir objeto UserModel a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'assignedProjects': assignedProjects,
    };
  }
}
