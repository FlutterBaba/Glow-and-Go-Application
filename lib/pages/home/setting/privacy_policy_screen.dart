import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Privacy Policy
Last updated: 17.05.2025.

This Privacy Policy explains how Hogo Studios Software Solutions collects, uses, and protects personal data when using the SalonApp mobile application.

1. Information We Collect
We may collect:
- Name and contact details (phone number, email)
- Appointment details (dates, services booked)
- Device information (non-personal, for analytics)
- Feedback provided by users

This data is collected when users:
- Register or use the app
- Book appointments
- Contact support

2. How We Use the Information
We use the collected information to:
- Manage and confirm appointments
- Send automated reminders and notifications
- Improve app functionality and support
- Communicate with salon clients (if authorized)

We do not sell or share your data with third parties for marketing.

3. Data Security
We implement security measures such as:
- Encrypted data transfer (SSL)
- Secure Firebase backend
- Restricted access to data by authorized personnel only

4. Third-Party Services
The App may use third-party platforms like Firebase by Google for hosting and messaging. These services follow their own privacy policies and comply with GDPR and other data protection regulations.

5. Your Rights
Users may request:
- Access to their data
- Correction or deletion of their data
- Withdrawal of consent at any time

Requests can be sent to: lazar@hogostudios.com

6. Changes to This Policy
We may update this Privacy Policy periodically. Any major changes will be announced within the app or via email.

7. Legal Jurisdiction
This Privacy Policy is governed by the laws of the Republic of Serbia. Legal matters shall be handled by the courts in Lazarevac.
''',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
        ),
      ),
    );
  }
}
