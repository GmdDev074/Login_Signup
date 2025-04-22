import 'package:flutter/material.dart';

class ListenView extends StatelessWidget {
  const ListenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listen'),
        backgroundColor: Colors.green.shade700,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.headphones, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Listen to your favorite content!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This is the Listen screen.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}