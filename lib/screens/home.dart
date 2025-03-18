import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'project_screen.dart';
import 'task_screen.dart';
import 'dashboard.dart';
import 'calendar.dart';
import 'profile.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UTAH Painting'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Proyectos'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectScreen())),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tareas'),
              onTap: () async {
                String? projectId = await _getFirstProjectId();
                if (projectId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskScreen(projectId: projectId)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No hay proyectos disponibles.')),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen())),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Calendario'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen())),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildGridItem(context, Icons.work, 'Proyectos', ProjectScreen()),
            _buildGridItem(context, Icons.task, 'Tareas', null),
            _buildGridItem(context, Icons.dashboard, 'Dashboard', DashboardScreen()),
            _buildGridItem(context, Icons.calendar_today, 'Calendario', CalendarScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, IconData icon, String title, Widget? screen) {
    return GestureDetector(
      onTap: () async {
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        } else {
          String? projectId = await _getFirstProjectId();
          if (projectId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskScreen(projectId: projectId)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No hay proyectos disponibles.')),
            );
          }
        }
      },
      child: Card(
        color: Colors.blueGrey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Future<String?> _getFirstProjectId() async {
    QuerySnapshot projects = await FirebaseFirestore.instance.collection('projects').get();
    if (projects.docs.isNotEmpty) {
      return projects.docs.first.id;
    }
    return null;
  }
}
