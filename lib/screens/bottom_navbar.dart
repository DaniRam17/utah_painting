import 'package:flutter/material.dart';
import 'project_screen.dart';
import 'dashboard.dart';
import 'calendar.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBar();
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar> {
  int _selectedItem = 0;
  final List<Widget> _screens = [
    ProjectScreen(),
    DashboardScreen(),
    CalendarScreen(),
  ];

  void _selectedScreen(int newSelectedItem) {
    setState(() {
      _selectedItem = newSelectedItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedItem,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Proyectos'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
        ],
        currentIndex: _selectedItem,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        onTap: _selectedScreen,
      ),
    );
  }
}