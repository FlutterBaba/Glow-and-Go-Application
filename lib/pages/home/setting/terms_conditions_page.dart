import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Terms & Conditions
Last updated: 17.05.2025.

These Terms and Conditions govern your use of the mobile application SalonApp provided by Hogo Studios Software Solutions. By using the App, you agree to be bound by these Terms.

1. License and Use
By purchasing a license, each salon is granted a limited, non-transferable, non-exclusive license to use the App for business purposes, subject to these Terms.

2. User Responsibilities
By using the App, you agree to:
- Not use the App for any unlawful or unauthorized purposes.
- Not attempt to reverse-engineer, decompile, or interfere with the App’s operation.
- Provide accurate and truthful information when registering or making appointments.

3. Intellectual Property
The App, including its source code, design, database, and user interface, is the exclusive property of Hogo Studios Software Solutions. The software is protected under applicable copyright and intellectual property laws.

🛡️ This software is legally patented and/or registered as intellectual property, and any unauthorized use, reproduction, or distribution is strictly prohibited.

Violations will be subject to legal action under the applicable laws of intellectual property protection.

4. Disclaimer of Liability
The App is provided “as is,” without warranties of any kind. We do not guarantee uninterrupted or error-free operation. We are not liable for any damages resulting from improper use, technical issues, or third-party interference.

5. Modifications
We reserve the right to update or modify these Terms at any time. Users will be notified of significant changes via the App or by email.

6. Governing Law and Jurisdiction
These Terms shall be governed by the laws of the Republic of Serbia. Any disputes shall be subject to the exclusive jurisdiction of the courts in Lazarevac.

🛡️ Intellectual Property Notice
The software and all associated services are the intellectual property of Hogo Studios Software Solutions. This system is protected by applicable intellectual property laws and/or registered as a patent. Unauthorized copying, reproduction, or distribution is strictly prohibited and will be prosecuted in accordance with the law.
''',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
        ),
      ),
    );
  }
}
