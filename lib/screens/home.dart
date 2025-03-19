import 'package:flutter/material.dart';
import 'tab_controller.dart'; // Menú lateral
import 'third_screen.dart'; // Nueva pantalla controladora

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ThirdScreen(), // 👈 Usa ThirdScreen como el controlador principal
    );
  }
}
