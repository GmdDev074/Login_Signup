import 'package:flutter/material.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  // List of FAQ questions and answers
  final List<Map<String, String>> faqs = const [
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to the login screen, click "Forgot Password," and follow the instructions to reset your password.',
    },
    {
      'question': 'How do I add a new lecture schedule?',
      'answer': 'Navigate to the Schedule view and use the calendar to add a new event.',
    },
    {
      'question': 'Can I sync my schedule with other devices?',
      'answer': 'Yes, your schedule is synced with your account and accessible on any device where you log in.',
    },
    {
      'question': 'Can I reset my password?',
      'answer': 'Yes, you can reset your account password from the forgot password section.',
    },
    {
      'question': 'Can I update my email?',
      'answer': 'No, you cannot update your email.',
    },
    {
      'question': 'Can I update my profile data?',
      'answer': 'Yes—you can update your profile data from the Profile view.',
    },
    {
      'question': 'How do I delete an event from my schedule?',
      'answer': 'Go to the Schedule view, swipe the event to the left to delete it, this operation can not be undo so be careful before deleting.',
    },
    {
      'question': 'Can I receive notifications for my events?',
      'answer': 'Yes, enable notifications in the app settings to receive alerts for your scheduled events.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'Visit the Contact Us page and submit your query through the provided form.',
    },
    {
      'question': 'Can I use the app offline?',
      'answer': 'Limited functionality is available offline; full features require an internet connection.',
    },
    {
      'question': 'How do I change my notification preferences?',
      'answer': 'Go to the Settings view and adjust your notification settings as needed.',
    },
    {
      'question': 'Can I export my schedule?',
      'answer': 'Yes, you can export your schedule as a calendar file from the Schedule view.',
    },
    {
      'question': 'What should I do if the app crashes?',
      'answer': 'Try restarting the app or updating to the latest version; contact support if the issue persists.',
    },
    {
      'question': 'Can I share my schedule with others?',
      'answer': 'Yes, use the share option in the Schedule view to send events to others.',
    },
    {
      'question': 'How do I update the app?',
      'answer': 'Check for updates in your device’s app store and install the latest version.',
    },
    {
      'question': 'Can I recover a deleted event?',
      'answer': 'No, deleted events cannot be recovered; please confirm before deleting.',
    },
    {
      'question': 'How do I update an event from my schedule?',
      'answer': 'Go to the Schedule view, swipe the event to the right to update it.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support',
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
                'Support',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Use ListView to display each FAQ in a card
              ListView.separated(
                shrinkWrap: true, // Ensure the ListView takes only the space it needs
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for the ListView (SingleChildScrollView handles it)
                itemCount: faqs.length,
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
                            faqs[index]['question']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Divider(color: Colors.black),
                          Text(
                            faqs[index]['answer']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Match the color from the image
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