import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'project_screen.dart';
import 'profile_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  // state
  int _selectedItem = 0;

  // widgets
  final List<Widget> _screens = [
    HomeScreen(),
    ProjectScreen(),
    ProfileScreen()
  ];

  void _selectedScreen(int newSelectedItem) {
    setState(() {
      _selectedItem = newSelectedItem;
    });
  }

  Widget? _conditionalFloatingButton() {
    if (_selectedItem == 0) {
      return FloatingActionButton(
        onPressed: () {
          print("=========================================> Click on add");
        },
        child: Icon(Icons.add),
      );
    }
    return null;
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.pushNamed(context, 'search');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab app"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {
            _navigateToSearch(context);
          }, icon: Icon(Icons.search))
        ],
      ),
      body: _screens[_selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        currentIndex: _selectedItem,
        selectedItemColor: Colors.amber[800],
        onTap: _selectedScreen,
      ),
      floatingActionButton: _conditionalFloatingButton(),
    );
  }
}