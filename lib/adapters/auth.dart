import 'package:firebase_auth/firebase_auth.dart';
import '../adapters/local_storage.dart';

class Auth {
  static Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    await LocalStorage.setLoginStatus(true);
    return userCredential;
  }

  static Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    await LocalStorage.setLoginStatus(true);
    return userCredential;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await LocalStorage.clearAll();
  }
}
