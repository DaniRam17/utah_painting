import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../adapters/http_adapter.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool isLoading = true;
  final HttpAdapter _httpAdapter = HttpAdapter();

  UserModel? get user => _user;

  UserProvider() {
    _loadUserData();
  }

  void _loadUserData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        _user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        if (_user!.profilePic.isEmpty) {
          _user!.profilePic = await _httpAdapter.getRandomProfilePic() ?? "";
          notifyListeners();
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

<<<<<<< HEAD
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
      return snapshot.docs.map((doc) => {
        'uid': doc.id,
        'name': doc['name'] ?? ''
      }).toList();
    } catch (e) {
      print('Error obteniendo usuarios: \$e');
      return [];
    }
  }

=======
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
  void updateUserProfile(String newName, String? newProfilePic) async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update({
        'name': newName,
        'profilePic': newProfilePic ?? _user!.profilePic,
      });

      _user = UserModel(
        uid: _user!.uid,
        name: newName,
        email: _user!.email,
        profilePic: newProfilePic ?? _user!.profilePic,
        assignedProjects: _user!.assignedProjects,
      );

      notifyListeners();
    }
  }
}
