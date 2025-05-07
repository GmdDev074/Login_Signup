import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  // List of terms and descriptions without numbering
  final List<Map<String, String>> terms = const [
    {
      'title': 'Use of the App',
      'description': 'You agree to use the app only for lawful purposes and in accordance with these terms.',
    },
    {
      'title': 'Account Responsibility',
      'description': 'You are responsible for maintaining the confidentiality of your account and password.',
    },
    {
      'title': 'Intellectual Property',
      'description': 'All content in the app is owned by Lecture Scheduler and protected by intellectual property laws.',
    },
    {
      'title': 'Limitation of Liability',
      'description': 'We are not liable for any damages arising from your use of the app.',
    },
    {
      'title': 'Changes to Terms',
      'description': 'We may update these terms from time to time. Continued use of the app constitutes acceptance of the updated terms.',
    },
    {
      'title': 'Contact Us',
      'description': 'For questions about these Terms and Conditions, please visit our Contact Us page.',
    },
    {
      'title': 'User Conduct',
      'description': 'You agree not to engage in any activity that interferes with or disrupts the app’s functionality.',
    },
    {
      'title': 'Termination',
      'description': 'We reserve the right to terminate your access to the app for violating these terms.',
    },
    {
      'title': 'Governing Law',
      'description': 'These terms are governed by the laws of the jurisdiction where our company is based.',
    },
    {
      'title': 'Third-Party Services',
      'description': 'The app may include links to third-party services, which are subject to their own terms.',
    },
    {
      'title': 'User Content',
      'description': 'Any content you submit to the app remains your property, but you grant us a license to use it for app functionality.',
    },
    {
      'title': 'Prohibited Activities',
      'description': 'You may not attempt to reverse-engineer, decompile, or hack the app.',
    },
    {
      'title': 'Service Availability',
      'description': 'We do not guarantee uninterrupted access to the app and may perform maintenance as needed.',
    },
    {
      'title': 'Indemnification',
      'description': 'You agree to indemnify us against claims arising from your misuse of the app.',
    },
    {
      'title': 'Disclaimer of Warranties',
      'description': 'The app is provided "as is" without warranties of any kind, express or implied.',
    },
    {
      'title': 'Age Restrictions',
      'description': 'You must be at least 13 years old to use the app.',
    },
    {
      'title': 'Data Usage',
      'description': 'You are responsible for any data charges incurred while using the app.',
    },
    {
      'title': 'Feedback',
      'description': 'Any feedback you provide about the app may be used by us without compensation.',
    },
    {
      'title': 'Dispute Resolution',
      'description': 'Any disputes arising from these terms will be resolved through binding arbitration.',
    },
    {
      'title': 'Updates to the App',
      'description': 'We may update the app periodically, and you may need to download updates to continue using it.',
    },
    {
      'title': 'Severability',
      'description': 'If any provision of these terms is found invalid, the remaining provisions remain in effect.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
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
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'By using the Lecture Scheduler app, you agree to these Terms and Conditions.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 16),
              // Use ListView to display each term in a card
              ListView.separated(
                shrinkWrap: true, // Ensure the ListView takes only the space it needs
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for the ListView (SingleChildScrollView handles it)
                itemCount: terms.length,
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
                            terms[index]['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Divider(color: Colors.black),
                          Text(
                            terms[index]['description']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}