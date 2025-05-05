import 'package:flutter/material.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
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
                'Support',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // White text for contrast
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Frequently Asked Questions\n\n'
                    '1: How do I reset my password?\n'
                    'Go to the login screen, click "Forgot Password," and follow the instructions to reset your password.\n\n'
                    '2: How do I add a new lecture schedule?\n'
                    'Navigate to the Schedule view and use the calendar to add a new event.\n\n'
                    '3: Can I sync my schedule with other devices?\n'
                    'Yes, your schedule is synced with your account and accessible on any device where you log in.\n\n'
                    '4: Can I reset my password?\n'
                    'Yes, you can reset your account password from the forgot password section.\n\n'
                    '5: Can I update my email?\n'
                    'No, you cannot update your email.\n\n'
                    '6: Can I update my profile data?\n'
                    'Yes—you can update your profile data from the Profile view.\n\n'
                    '7: How do I delete an event from my schedule?\n'
                    'Go to the Schedule view, swipe the event to the left to delete it, this operation can not be undo so be careful before deleting.\n\n'
                    '8: Can I receive notifications for my events?\n'
                    'Yes, enable notifications in the app settings to receive alerts for your scheduled events.\n\n'
                    '9: How do I contact customer support?\n'
                    'Visit the Contact Us page and submit your query through the provided form.\n\n'
                    '10: Can I use the app offline?\n'
                    'Limited functionality is available offline; full features require an internet connection.\n\n'
                    '11: How do I change my notification preferences?\n'
                    'Go to the Settings view and adjust your notification settings as needed.\n\n'
                    '12: Can I export my schedule?\n'
                    'Yes, you can export your schedule as a calendar file from the Schedule view.\n\n'
                    '13: What should I do if the app crashes?\n'
                    'Try restarting the app or updating to the latest version; contact support if the issue persists.\n\n'
                    '14: Can I share my schedule with others?\n'
                    'Yes, use the share option in the Schedule view to send events to others.\n\n'
                    '15: How do I update the app?\n'
                    'Check for updates in your device’s app store and install the latest version.\n\n'
                    '16: Can I recover a deleted event?\n'
                    'No, deleted events cannot be recovered; please confirm before deleting.\n\n'
                    '17: How do I update an event from my schedule?\n'
                    'Go to the Schedule view, swipe the event to the right to update it.\n\n'
                    'For further assistance, please visit our Contact Us page.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}