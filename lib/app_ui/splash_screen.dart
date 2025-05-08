import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:Lecture_Scheduler/app_ui/main_screen.dart';
import 'package:Lecture_Scheduler/app_ui/login.dart';

// Custom scale + fade transition with background color to avoid white edges
class ScaleFadePageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  ScaleFadePageRoute({required this.builder})
      : super(
    opaque: true, // Ensure the route covers the previous screen
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginScale = 0.8; // Start slightly scaled down
      const endScale = 1.0; // End at full size
      const curve = Curves.easeOutCubic; // Snappy, modern curve

      // Scale transition
      var scaleTween = Tween(begin: beginScale, end: endScale).chain(CurveTween(curve: curve));
      var scaleAnimation = animation.drive(scaleTween);

      // Fade transition
      var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
      var fadeAnimation = animation.drive(fadeTween);

      // Wrap in a colored container to avoid white edges
      return Container(
        color: Colors.blue.shade100, // Match SplashScreen background
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 600), // Snappy duration
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for 5 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Create linear progress animation from 0.0 to 1.0
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Start the animation
    _controller.forward();

    // Remove native splash screen after a slight delay to ensure Flutter UI is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        FlutterNativeSplash.remove();
      });
    });

    // Check login status and navigate after 5 seconds with custom scale + fade transition
    Timer(const Duration(seconds: 5), () async {
      final isLoggedIn = await _checkLoginStatus();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          ScaleFadePageRoute(
            builder: (context) => isLoggedIn ? const MainScreen() : const MyLogin(),
          ),
        );
      }
    });
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // Also check Firebase auth state
    return isLoggedIn && FirebaseAuth.instance.currentUser != null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Lecture Scheduler',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blue,
                    minHeight: 8,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}