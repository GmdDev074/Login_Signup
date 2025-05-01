import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Lecture_Scheduler/app_ui/login.dart';
import 'package:Lecture_Scheduler/app_ui/register.dart';
import 'package:Lecture_Scheduler/app_ui/forgot_password.dart';
import 'package:Lecture_Scheduler/app_ui/main_screen.dart';
import 'package:Lecture_Scheduler/app_ui/splash_screen.dart';
import 'package:Lecture_Scheduler/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await NotificationService.initialize();
  //await NotificationService.requestPermissions(); // Optional, for Android 13+
  //await NotificationService.requestBatteryOptimizationExemption();  // battery optimization
  //await NotificationService.testNotification(); // For initial testing
  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // Also check Firebase auth state
    return isLoggedIn && FirebaseAuth.instance.currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const MainScreen() : const MyLogin();
        },
      ),
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