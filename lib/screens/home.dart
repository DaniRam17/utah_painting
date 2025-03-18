import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '/providers/user_provider.dart';
import 'project_screen.dart';
import 'task_screen.dart';
import 'dashboard.dart';
import 'calendar.dart';
import 'profile.dart';
import 'login.dart';
import 'bottom_navbar.dart';
import '../adapters/local_storage.dart';
import '../adapters/auth.dart';

class HomeScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
    await Auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user ?? LocalStorage.getUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('UTAH Painting', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user?.profilePic.isNotEmpty == true
                        ? NetworkImage(user!.profilePic)
                        : AssetImage('https://flic.kr/p/2qSEg6P') as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  userProvider.isLoading
                      ? Text('Cargando...', style: TextStyle(color: Colors.white))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'Usuario', style: TextStyle(color: Colors.white, fontSize: 18)),
                            Text(user?.email ?? '', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                ],
              ),
            ),
            _buildDrawerItem(context, Icons.work, 'Proyectos', ProjectScreen()),
            _buildDrawerItem(context, Icons.task, 'Tareas', TaskScreen(projectId: '')), // Se debe pasar projectId
            _buildDrawerItem(context, Icons.dashboard, 'Dashboard', DashboardScreen()),
            _buildDrawerItem(context, Icons.calendar_today, 'Calendario', CalendarScreen()),
            _buildDrawerItem(context, Icons.person, 'Perfil', ProfileScreen()),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: MyBottomNavigationBar(),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(179, 9, 52, 126)),
      title: Text(title, style: TextStyle(color: const Color.fromARGB(255, 42, 41, 41))),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
    );
  }
}