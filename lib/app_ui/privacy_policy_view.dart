import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  // List of privacy policy sections without numbering
  final List<Map<String, String>> privacySections = const [
    {
      'title': 'Information We Collect',
      'description': 'We may collect personal information such as your name, email address, and phone number when you register or use our services.',
    },
    {
      'title': 'How We Use Your Information',
      'description': 'Your information is used to provide and improve our services, personalize your experience, and communicate with you.',
    },
    {
      'title': 'Data Security',
      'description': 'We implement appropriate security measures to protect your information from unauthorized access or disclosure.',
    },
    {
      'title': 'Sharing Your Information',
      'description': 'We do not share your personal information with third parties except as required by law or with your consent.',
    },
    {
      'title': 'Contact Us',
      'description': 'If you have any questions about this Privacy Policy, please visit our Contact Us page.',
    },
    {
      'title': 'Cookies and Tracking Technologies',
      'description': 'We may use cookies or similar technologies to enhance your experience and analyze app usage.',
    },
    {
      'title': 'User Account Data',
      'description': 'Your account data, such as login credentials and profile details, is stored securely to enable app functionality.',
    },
    {
      'title': 'Schedule Data',
      'description': 'Event and schedule information you input is stored to provide scheduling features and is not shared publicly.',
    },
    {
      'title': 'Data Retention',
      'description': 'We retain your personal information only as long as necessary to provide our services or comply with legal obligations.',
    },
    {
      'title': 'Data Deletion',
      'description': 'You can request deletion of your personal data through the app settings or by contacting us.',
    },
    {
      'title': 'Third-Party Services',
      'description': 'We may use third-party services for analytics or cloud storage, which comply with our privacy standards.',
    },
    {
      'title': 'Children’s Privacy',
      'description': 'Our app is not intended for users under 13, and we do not knowingly collect data from children.',
    },
    {
      'title': 'Data Transfers',
      'description': 'Your data may be transferred to servers in other countries, subject to strict security protocols.',
    },
    {
      'title': 'User Consent',
      'description': 'By using our app, you consent to the collection and use of your data as outlined in this policy.',
    },
    {
      'title': 'Updates to This Policy',
      'description': 'We may update this Privacy Policy periodically and will notify you of significant changes.',
    },
    {
      'title': 'Access to Your Data',
      'description': 'You can review and update your personal information via the Profile view in the app.',
    },
    {
      'title': 'Opt-Out Options',
      'description': 'You may opt out of non-essential data collection, such as analytics, through app settings.',
    },
    {
      'title': 'Data Breach Procedures',
      'description': 'In the event of a data breach, we will notify affected users and take prompt corrective action.',
    },
    {
      'title': 'Automated Decision-Making',
      'description': 'We do not use automated decision-making or profiling that significantly affects you.',
    },
    {
      'title': 'Your Rights',
      'description': 'You have the right to access, correct, or delete your data, subject to applicable laws.',
    },
    {
      'title': 'Location Data',
      'description': 'We may collect location data if you enable location-based features, which you can disable at any time.',
    },
    {
      'title': 'Analytics and Usage Data',
      'description': 'We collect anonymized usage data to improve app performance and user experience.',
    },
    {
      'title': 'Governing Law',
      'description': 'This Privacy Policy is governed by the laws of the jurisdiction where our company is based.',
    },
    {
      'title': 'Complaints',
      'description': 'If you have concerns about our data practices, you may file a complaint through our Contact Us page.',
    },
    {
      'title': 'Data Minimization',
      'description': 'We collect only the data necessary to provide our services and fulfill our obligations.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
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
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our Lecture Scheduler app.',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 16),
              // Use ListView to display each privacy section in a card
              ListView.separated(
                shrinkWrap: true, // Ensure the ListView takes only the space it needs
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for the ListView (SingleChildScrollView handles it)
                itemCount: privacySections.length,
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
                            privacySections[index]['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Divider(color: Colors.black),
                          Text(
                            privacySections[index]['description']!,
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