import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:Lecture_Scheduler/app_ui/login.dart';
import 'package:Lecture_Scheduler/app_ui/register.dart';
import 'package:Lecture_Scheduler/app_ui/forgot_password.dart';
import 'package:Lecture_Scheduler/app_ui/main_screen.dart';
import 'package:Lecture_Scheduler/app_ui/splash_screen.dart';
import 'package:Lecture_Scheduler/services/notification_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app_ui/contact_us_view.dart';
import 'app_ui/how_to_use_view.dart';
import 'app_ui/privacy_policy_view.dart';
import 'app_ui/rate_us_view.dart';
import 'app_ui/support_view.dart';
import 'app_ui/terms_and_conditions_view.dart';

// FirebaseOptions for your project
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyAHXifepGZtrkRkeBhohsexTgK1An54EXM",
  appId: "1:999445788579:android:26a9e5c575300eb2434c16",
  messagingSenderId: "999445788579",
  projectId: "flutter-app-26cac",
  authDomain: "flutter-app-26cac.firebaseapp.com",
  storageBucket: "flutter-app-26cac.appspot.com",
);

// Singleton class to manage Firebase initialization
class FirebaseInitializer {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) {
      print('Firebase already initialized, skipping...');
      return;
    }

    try {
      print('Initializing Firebase...');
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: firebaseOptions);
      }
      print('Firebase initialized successfully.');
      _isInitialized = true;
    } catch (e) {
      print('Error initializing Firebase: $e');
      if (e.toString().contains('duplicate-app')) {
        print('Firebase app "[DEFAULT]" already exists, using existing instance.');
        _isInitialized = true; // Proceed with existing app
      } else {
        rethrow; // Rethrow other errors
      }
    }
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Preserve native splash screen until Flutter is ready
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase with singleton
  await FirebaseInitializer.initialize();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // app background colour
      ),
      home: const SplashScreen(),
      routes: {
        'splash': (context) => const SplashScreen(),
        'login': (context) => const MyLogin(),
        'register': (context) => const MyRegister(),
        'forgot_password': (context) => const MyForgotPassword(),
        'main': (context) => const MainScreen(),
        '/privacy_policy': (context) => const PrivacyPolicyView(),
        '/terms_and_conditions': (context) => const TermsAndConditionsView(),
        '/rate_us': (context) => const RateUsView(),
        '/support': (context) => const SupportView(),
        '/contact_us': (context) => const ContactUsView(),
        '/how_to_use': (context) => const HowToUseView(),
      },
    );
  }
}