import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/screens/home.dart';
import '/screens/login.dart';
import '/screens/third_screen.dart';
import '/screens/project_screen.dart';
import '/screens/task_screen.dart';
import '/screens/profile.dart';
import '/screens/calendar.dart';
import '/screens/dashboard.dart';
import '/providers/user_provider.dart';
import '/providers/project_provider.dart';
import '/providers/task_provider.dart';
import '/adapters/local_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.init();
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'UTAH Painting',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            color: Colors.blueAccent,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/home': (context) => HomeScreen(),
          '/app-controller': (context) => ThirdScreen(),
          '/projects': (context) => ProjectScreen(),
          '/tasks': (context) => TaskScreen(projectId: ''), 
          '/dashboard': (context) => DashboardScreen(),
          '/calendar': (context) => CalendarScreen(),
          '/profile': (context) => ProfileScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = LocalStorage.getLoginStatus();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
          );
        }
        if (snapshot.hasData || isLoggedIn) {
          return ThirdScreen();
        }
        return LoginScreen();
      },
    );
  }
}
