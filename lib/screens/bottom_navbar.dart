import 'package:flutter/material.dart';
import 'project_screen.dart';
import 'dashboard.dart';
import 'calendar.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected; // Callback para cambiar de pantalla

  MyBottomNavigationBar({required this.selectedIndex, required this.onItemSelected});

  final List<Widget> _screens = [
    ProjectScreen(),
    DashboardScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Proyectos'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        onTap: onItemSelected, // 👈 Usa la función pasada desde `ThirdScreen`
      ),
    );
  }
}
