import 'package:flutter/material.dart';
import 'package:utah_painting/presentation/screens/projects/project_list.dart';
import 'package:utah_painting/presentation/screens/tasks/task_list.dart';
import 'package:utah_painting/presentation/screens/calendar/calendar.dart' ;
import 'package:utah_painting/presentation/screens/home/dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TaskListScreen(projectId: 'your_project_id'),
    const ProjectListScreen(),
    const CalendarScreen(),
    const DashboardScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tareas"),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: "Proyectos"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendario"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
