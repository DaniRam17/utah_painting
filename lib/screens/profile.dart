import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../adapters/http_adapter.dart';
<<<<<<< HEAD
import 'tab_controller.dart'; // Importa el menú lateral
=======
>>>>>>> 455ab0d336b011cd420e673883058461470b706b

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final HttpAdapter _httpAdapter = HttpAdapter();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
<<<<<<< HEAD
  
  String profilePic = "https://via.placeholder.com/150"; // Imagen por defecto
=======
  String profilePic = '';
>>>>>>> 455ab0d336b011cd420e673883058461470b706b

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _db.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          nameController.text = userDoc['name'];
          emailController.text = userDoc['email'];
<<<<<<< HEAD
          profilePic = userDoc['profilePic'] ?? "https://via.placeholder.com/150";
=======
          profilePic = userDoc['profilePic'] ?? '';
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
        });
      }
    }
  }

  void _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).update({
        'name': nameController.text,
        'email': emailController.text,
        'profilePic': profilePic,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    }
  }

  Future<void> _setRandomProfilePic() async {
    String? newProfilePic = await _httpAdapter.getRandomProfilePic();
    if (newProfilePic != null) {
      setState(() {
        profilePic = newProfilePic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      drawer: TabControllerDrawer(), // Agrega el menú lateral
      appBar: AppBar(title: Text('Perfil')),
=======
      appBar: AppBar(title: Text('Perfil'), backgroundColor: Colors.blueAccent),
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
<<<<<<< HEAD
              backgroundImage: NetworkImage(profilePic),
=======
              backgroundImage: profilePic.isNotEmpty ? NetworkImage(profilePic) : AssetImage('https://flic.kr/p/2qSEg6P') as ImageProvider,
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _setRandomProfilePic,
              child: Text('Generar Imagen Aleatoria', style: TextStyle(color: Colors.blueAccent)),
            ),
            SizedBox(height: 20),
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
            SizedBox(height: 10),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email'), enabled: false),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Actualizar Perfil'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
