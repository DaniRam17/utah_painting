import 'package:flutter/material.dart';
import 'project_screen.dart';
import 'dashboard.dart';
import 'calendar.dart';

<<<<<<< HEAD
class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected; // Callback para cambiar de pantalla

  MyBottomNavigationBar({required this.selectedIndex, required this.onItemSelected});

=======
class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBar();
}

class _MyBottomNavigationBar extends State<MyBottomNavigationBar> {
  int _selectedItem = 0;
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
  final List<Widget> _screens = [
    ProjectScreen(),
    DashboardScreen(),
    CalendarScreen(),
  ];

<<<<<<< HEAD
=======
  void _selectedScreen(int newSelectedItem) {
    setState(() {
      _selectedItem = newSelectedItem;
    });
  }

>>>>>>> 455ab0d336b011cd420e673883058461470b706b
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
<<<<<<< HEAD
        index: selectedIndex,
=======
        index: _selectedItem,
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Proyectos'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
        ],
<<<<<<< HEAD
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        onTap: onItemSelected, // 👈 Usa la función pasada desde `ThirdScreen`
      ),
    );
  }
}
=======
        currentIndex: _selectedItem,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        onTap: _selectedScreen,
      ),
    );
  }
}
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
