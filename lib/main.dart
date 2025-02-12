// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utah_painting/app.dart';
import 'package:utah_painting/providers/auth_provider.dart';
import 'package:utah_painting/providers/project_provider.dart';
import 'package:utah_painting/providers/task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}