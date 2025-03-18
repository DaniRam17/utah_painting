import 'package:flutter/material.dart';
import 'project_screen.dart';
import 'dashboard.dart';
import 'calendar.dart';

class MyTabController extends StatefulWidget {
  @override
  State<MyTabController> createState() => _MyTabController();
}

class _MyTabController extends State<MyTabController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gestión de Proyectos"),
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.work), text: "Proyectos"),
              Tab(icon: Icon(Icons.dashboard), text: "Dashboard"),
              Tab(icon: Icon(Icons.calendar_today), text: "Calendario"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProjectScreen(),
            DashboardScreen(),
            CalendarScreen(),
          ],
        ),
      ),
    );
  }
}
