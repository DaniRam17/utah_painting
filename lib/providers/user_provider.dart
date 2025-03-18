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
