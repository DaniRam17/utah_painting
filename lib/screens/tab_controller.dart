import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/project_screen.dart';
import '../screens/task_screen.dart';
import '../screens/dashboard.dart';
import '../screens/calendar.dart';
import '../screens/profile.dart';
import '../screens/login.dart';
import '../adapters/local_storage.dart';
import '../adapters/auth.dart';

class TabControllerDrawer extends StatelessWidget {
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

    return Drawer(
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
                      : NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
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
          _buildDrawerItem(context, Icons.work, 'Proyectos', '/projects'),
          _buildDrawerItem(context, Icons.task, 'Tareas', '/tasks'),
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
          _buildDrawerItem(context, Icons.calendar_today, 'Calendario', '/calendar'),
          _buildDrawerItem(context, Icons.person, 'Perfil', '/profile'),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  /// Método para construir los elementos del menú
  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(color: Colors.black87)),
      onTap: () {
        Navigator.pop(context); // Cerrar el Drawer antes de navegar
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
