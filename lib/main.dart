import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_app/app_ui/login.dart';
import 'package:test_app/app_ui/register.dart';
import 'package:test_app/app_ui/forgot_password.dart';
import 'package:test_app/services/notification_service.dart';

import 'app_ui/main_screen.dart';
import 'app_ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();
  await NotificationService.requestPermissions(); // Optional, for Android 13+
  await NotificationService.requestBatteryOptimizationExemption();  // battery optimization
  await NotificationService.testNotification(); // For initial testing

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        'splash': (context) => const SplashScreen(),
        'login': (context) => const MyLogin(),
        'register': (context) => const MyRegister(),
        'forgot_password': (context) => const MyForgotPassword(),
        'main': (context) => const MainScreen(),
      },
    );
  }
}