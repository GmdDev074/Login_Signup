import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.white,
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
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // White text for contrast
                ),
              ),
              SizedBox(height: 16),
              Text(
                'By using the Lecture Scheduler app, you agree to these Terms and Conditions.\n\n'
                    '1. Use of the App\n'
                    'You agree to use the app only for lawful purposes and in accordance with these terms.\n\n'
                    '2. Account Responsibility\n'
                    'You are responsible for maintaining the confidentiality of your account and password.\n\n'
                    '3. Intellectual Property\n'
                    'All content in the app is owned by Lecture Scheduler and protected by intellectual property laws.\n\n'
                    '4. Limitation of Liability\n'
                    'We are not liable for any damages arising from your use of the app.\n\n'
                    '5. Changes to Terms\n'
                    'We may update these terms from time to time. Continued use of the app constitutes acceptance of the updated terms.\n\n'
                    '6. Contact Us\n'
                    'For questions about these Terms and Conditions, please visit our Contact Us page.\n\n'
                    '7. User Conduct\n'
                    'You agree not to engage in any activity that interferes with or disrupts the app’s functionality.\n\n'
                    '8. Termination\n'
                    'We reserve the right to terminate your access to the app for violating these terms.\n\n'
                    '9. Governing Law\n'
                    'These terms are governed by the laws of the jurisdiction where our company is based.\n\n'
                    '10. Third-Party Services\n'
                    'The app may include links to third-party services, which are subject to their own terms.\n\n'
                    '11. User Content\n'
                    'Any content you submit to the app remains your property, but you grant us a license to use it for app functionality.\n\n'
                    '12. Prohibited Activities\n'
                    'You may not attempt to reverse-engineer, decompile, or hack the app.\n\n'
                    '13. Service Availability\n'
                    'We do not guarantee uninterrupted access to the app and may perform maintenance as needed.\n\n'
                    '14. Indemnification\n'
                    'You agree to indemnify us against claims arising from your misuse of the app.\n\n'
                    '15. Disclaimer of Warranties\n'
                    'The app is provided "as is" without warranties of any kind, express or implied.\n\n'
                    '16. Age Restrictions\n'
                    'You must be at least 13 years old to use the app.\n\n'
                    '17. Data Usage\n'
                    'You are responsible for any data charges incurred while using the app.\n\n'
                    '18. Feedback\n'
                    'Any feedback you provide about the app may be used by us without compensation.\n\n'
                    '19. Dispute Resolution\n'
                    'Any disputes arising from these terms will be resolved through binding arbitration.\n\n'
                    '20. Updates to the App\n'
                    'We may update the app periodically, and you may need to download updates to continue using it.\n\n'
                    '21. Severability\n'
                    'If any provision of these terms is found invalid, the remaining provisions remain in effect.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}