import 'package:flutter/material.dart';

class HowToUseView extends StatelessWidget {
  const HowToUseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Use'),
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to Use Lecture Scheduler',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // White text for contrast
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Follow these steps to get started with the Lecture Scheduler app:\n\n'
                    '1. Log In or Sign Up\n'
                    'Create an account or log in using your email and password.\n\n'
                    '2. Navigate the App\n'
                    'Use the bottom navigation bar to switch between Home, Schedule, Subjects, and Profile views.\n\n'
                    '3. Manage Your Schedule\n'
                    'Go to the Schedule view to add, edit, or delete lecture events using the calendar.\n\n'
                    '4. View Subjects\n'
                    'Check the Subjects view to see your enrolled courses and their details.\n\n'
                    '5. Update Your Profile\n'
                    'Visit the Profile view to update your personal information.\n\n'
                    '6. Access Support\n'
                    'Use the drawer to access Support, Contact Us, or other resources if you need help.\n\n'
                    'For more assistance, please visit our Contact Us page.',
                style: TextStyle(fontSize: 16, color: Colors.black), // White text for contrast
              ),
            ],
          ),
        ),
      ),
    );
  }
}