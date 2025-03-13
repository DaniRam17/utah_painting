import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'package:provider/provider.dart';
import 'package:utah_painting/app.dart';
import 'package:utah_painting/providers/auth_provider.dart';
import 'package:utah_painting/providers/project_provider.dart';
import 'package:utah_painting/providers/task_provider.dart';
import 'package:utah_painting/providers/calendar_provider.dart';
import 'package:utah_painting/providers/notification_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}