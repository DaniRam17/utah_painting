import 'package:flutter/material.dart';
<<<<<<< HEAD
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
=======

class ThirdScreen extends StatefulWidget {
  @override
  State<ThirdScreen> createState() => _ThirdScreen();
}

class _ThirdScreen extends State<ThirdScreen> {
  void _goToAppController(BuildContext context) {
    Navigator.pushNamed(context, 'app-controller');
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: Text("UTAH Painting")),
      drawer: TabControllerDrawer(),
      body: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _changeScreen,
=======
      appBar: AppBar(
        title: const Text("Third Screen"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: ElevatedButton(
            onPressed: () { _goToAppController(context); },
            child: const Text("Go Back", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
>>>>>>> 455ab0d336b011cd420e673883058461470b706b
      ),
    );
  }
}
