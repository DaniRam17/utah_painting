// Ensure the correct path to firebase_options.dart
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../lib/main.dart';
import '../lib/screens/home.dart';
import '../lib/screens/login.dart';
import 'firebase_options.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  });

  testWidgets('Verifica que la pantalla de login tiene los campos necesarios', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Email y Password
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('Verifica que se cargan proyectos en ProjectScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProjectScreen()));

    await tester.pump(); // Permitir que el StreamBuilder cargue los datos

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Verifica que AuthWrapper muestra HomeScreen cuando el usuario está autenticado', (WidgetTester tester) async {
    // Simula un usuario autenticado
    final user = User(
      uid: '123',
      email: 'test@example.com',
      displayName: 'Test User',
    );
    when(FirebaseAuth.instance.authStateChanges()).thenAnswer((_) => Stream.value(user));

    await tester.pumpWidget(MyApp());

    await tester.pump(); // Permitir que el StreamBuilder cargue los datos

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Verifica que AuthWrapper muestra LoginScreen cuando el usuario no está autenticado', (WidgetTester tester) async {
    // Simula que no hay usuario autenticado
    when(FirebaseAuth.instance.authStateChanges()).thenAnswer((_) => Stream.value(null));

    await tester.pumpWidget(MyApp());

    await tester.pump(); // Permitir que el StreamBuilder cargue los datos

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}