import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium ?? TextStyle();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for Gestio App',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Your privacy is important to us. It is Manager\'s policy to respect your privacy regarding any information we may collect from you across our app, Gestio.',
                style: textStyle,
              ),
              const SizedBox(height: 16.0),
              Text(
                '1. Information We Collect\n'
                'We may collect the following types of information when you use our app:\n'
                '- Personal Information: Name, email address, etc., provided voluntarily.\n'
                '- Usage Data: Information about your interaction with our app, such as pages visited, actions taken, etc.\n',
                style: textStyle,
              ),
              const SizedBox(height: 16.0),
              Text(
                '2. How We Use Your Information\n'
                'We may use the information collected to:\n'
                '- Provide and maintain our app.\n'
                '- Improve, personalize, and expand our app\'s features.\n'
                '- Communicate with you, either directly or through one of our partners, including for customer service, to provide updates and other information relating to the app, and for marketing and promotional purposes.\n',
                style: textStyle,
              ),
              const SizedBox(height: 16.0),
              Text(
                '3. Security of Your Information\n'
                'We value your trust in providing us with your information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.\n',
                style: textStyle,
              ),
              const SizedBox(height: 16.0),
              Text(
                '4. Changes to This Privacy Policy\n'
                'We may update our Privacy Policy from time to time. You are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.\n',
                style: textStyle,
              ),
              const SizedBox(height: 16.0),
              Text(
                '5. Contact Us\n'
                'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at SiyadSiyad016@gmail.com\n',
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
