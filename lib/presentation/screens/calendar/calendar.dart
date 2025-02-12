import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Center(
        child: Text(
          'Aquí irá el calendario de tareas y proyectos.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
