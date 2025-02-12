import 'package:flutter/material.dart';
import 'package:utah_painting/presentation/screens/auth/login.dart';
import 'package:utah_painting/presentation/screens/home/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTAH Painting',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}