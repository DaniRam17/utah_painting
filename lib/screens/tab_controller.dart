import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'project_screen.dart';
import 'profile_screen.dart';

class MyTabController extends StatefulWidget {
  @override
  State<MyTabController> createState() => _MyTabControllerState();
}

class _MyTabControllerState extends State<MyTabController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.business), text: "Projects"),
            Tab(icon: Icon(Icons.person), text: "Profile"),
          ]),
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(children: [
          HomeScreen(),
          ProjectScreen(),
          ProfileScreen(),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("=========================================> Click on add");
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}