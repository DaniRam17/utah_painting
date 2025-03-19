import 'package:cloud_firestore/cloud_firestore.dart';
import '../adapters/http_adapter.dart';

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

  // Convertir Firestore Document a UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePic: data['profilePic'] ?? '',
      assignedProjects: List<String>.from(data['assignedProjects'] ?? []),
    );
  }

  // Convertir UserModel a Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'assignedProjects': assignedProjects,
    };
  }

  // Obtener una imagen de perfil aleatoria si no se ha asignado una
  static Future<String> getDefaultProfilePic() async {
    final HttpAdapter httpAdapter = HttpAdapter();
    return await httpAdapter.getRandomProfilePic() ?? "https://via.placeholder.com/150";
  }
}
