import 'package:flutter/material.dart';

class HowToUseView extends StatelessWidget {
  const HowToUseView({super.key});

  // List of steps and descriptions
  final List<Map<String, String>> steps = const [
    {
      'step': 'Log In or Sign Up',
      'description': 'Create an account or log in using your email and password.',
    },
    {
      'step': 'Navigate the App',
      'description': 'Use the bottom navigation bar to switch between Home, Schedule, Subjects, and Profile views.',
    },
    {
      'step': 'Manage Your Schedule',
      'description': 'Go to the Schedule view to add, edit, or delete lecture events using the calendar.',
    },
    {
      'step': 'View Subjects',
      'description': 'Check the Subjects view to see your enrolled courses and their details.',
    },
    {
      'step': 'Update Your Profile',
      'description': 'Visit the Profile view to update your personal information.',
    },
    {
      'step': 'Access Support',
      'description': 'Use the drawer to access Support, Contact Us, or other resources if you need help.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to Use',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to Use Lecture Scheduler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Use ListView to display each step in a card
              ListView.separated(
                shrinkWrap: true, // Ensure the ListView takes only the space it needs
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for the ListView (SingleChildScrollView handles it)
                itemCount: steps.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white, // Set card color to white
                    elevation: 4, // Add elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            steps[index]['step']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Divider(color: Colors.black),
                          Text(
                            steps[index]['description']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Match the color from the SupportView
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'For more assistance, please visit our Contact Us page.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}