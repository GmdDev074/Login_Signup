import 'dart:async';
import 'package:flutter/material.dart';

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

    // Navigate to Login after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, 'login');
    });
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
            //Optional logo (uncomment if asset exists)
            Image.asset(
              'assets/app_logo.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Flutter App',
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