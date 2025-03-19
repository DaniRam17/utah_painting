import 'package:flutter/material.dart';
import 'tab_controller.dart';
import 'bottom_navbar.dart';

class ThirdScreen extends StatefulWidget {
  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  int _selectedIndex = 0;

  void _changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UTAH Painting")),
      drawer: TabControllerDrawer(),
      body: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _changeScreen,
      ),
    );
  }
}
