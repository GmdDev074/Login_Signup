import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white, // Set background color to green
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // White text for contrast
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our Lecture Scheduler app.\n\n'
                    '1. Information We Collect\n'
                    'We may collect personal information such as your name, email address, and phone number when you register or use our services.\n\n'
                    '2. How We Use Your Information\n'
                    'Your information is used to provide and improve our services, personalize your experience, and communicate with you.\n\n'
                    '3. Data Security\n'
                    'We implement appropriate security measures to protect your information from unauthorized access or disclosure.\n\n'
                    '4. Sharing Your Information\n'
                    'We do not share your personal information with third parties except as required by law or with your consent.\n\n'
                    '5. Contact Us\n'
                    'If you have any questions about this Privacy Policy, please visit our Contact Us page.\n\n'
                    '6. Cookies and Tracking Technologies\n'
                    'We may use cookies or similar technologies to enhance your experience and analyze app usage.\n\n'
                    '7. User Account Data\n'
                    'Your account data, such as login credentials and profile details, is stored securely to enable app functionality.\n\n'
                    '8. Schedule Data\n'
                    'Event and schedule information you input is stored to provide scheduling features and is not shared publicly.\n\n'
                    '9. Data Retention\n'
                    'We retain your personal information only as long as necessary to provide our services or comply with legal obligations.\n\n'
                    '10. Data Deletion\n'
                    'You can request deletion of your personal data through the app settings or by contacting us.\n\n'
                    '11. Third-Party Services\n'
                    'We may use third-party services for analytics or cloud storage, which comply with our privacy standards.\n\n'
                    '12. Children’s Privacy\n'
                    'Our app is not intended for users under 13, and we do not knowingly collect data from children.\n\n'
                    '13. Data Transfers\n'
                    'Your data may be transferred to servers in other countries, subject to strict security protocols.\n\n'
                    '14. User Consent\n'
                    'By using our app, you consent to the collection and use of your data as outlined in this policy.\n\n'
                    '15. Updates to This Policy\n'
                    'We may update this Privacy Policy periodically and will notify you of significant changes.\n\n'
                    '16. Access to Your Data\n'
                    'You can review and update your personal information via the Profile view in the app.\n\n'
                    '17. Opt-Out Options\n'
                    'You may opt out of non-essential data collection, such as analytics, through app settings.\n\n'
                    '18. Data Breach Procedures\n'
                    'In the event of a data breach, we will notify affected users and take prompt corrective action.\n\n'
                    '19. Automated Decision-Making\n'
                    'We do not use automated decision-making or profiling that significantly affects you.\n\n'
                    '20. Your Rights\n'
                    'You have the right to access, correct, or delete your data, subject to applicable laws.\n\n'
                    '21. Location Data\n'
                    'We may collect location data if you enable location-based features, which you can disable at any time.\n\n'
                    '22. Analytics and Usage Data\n'
                    'We collect anonymized usage data to improve app performance and user experience.\n\n'
                    '23. Governing Law\n'
                    'This Privacy Policy is governed by the laws of the jurisdiction where our company is based.\n\n'
                    '24. Complaints\n'
                    'If you have concerns about our data practices, you may file a complaint through our Contact Us page.\n\n'
                    '25. Data Minimization\n'
                    'We collect only the data necessary to provide our services and fulfill our obligations.',
                style: TextStyle(fontSize: 16, color: Colors.black), // White text for contrast
              ),
            ],
          ),
        ),
      ),
    );
  }
}