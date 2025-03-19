import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../adapters/db.dart';
import '../models/user.dart';
import '../screens/home.dart';
import '../adapters/http_adapter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();
  final HttpAdapter _httpAdapter = HttpAdapter();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Obtener imagen de perfil aleatoria
      String profilePic = await _httpAdapter.getRandomProfilePic() ?? "";

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        name: nameController.text,
        email: emailController.text,
        profilePic: profilePic,
        assignedProjects: [],
      );
      await _db.createUser(newUser);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print('Error al registrar: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text('Registrarse')),
          ],
        ),
      ),
    );
  }
}