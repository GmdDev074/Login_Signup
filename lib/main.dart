import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_app/app_ui/login.dart';
import 'package:test_app/app_ui/register.dart';
import 'package:test_app/app_ui/forgot_password.dart';

import 'app_ui/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      routes: {
        'login': (context) => const MyLogin(),
        'register': (context) => const MyRegister(),
        'forgot_password': (context) => const MyForgotPassword(),
        'main': (context) => const MainScreen(),
      },
    );
  }
}