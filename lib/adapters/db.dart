import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtener datos de un usuario por UID
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!, uid);
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  /// Crear un usuario en Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print('Error creando usuario: $e');
    }
  }

  /// Obtener todos los proyectos
  Stream<QuerySnapshot> getProjects() {
    return _db.collection('projects').snapshots();
  }
}
