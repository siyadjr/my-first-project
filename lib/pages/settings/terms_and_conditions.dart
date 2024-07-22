import 'package:flutter/material.dart';
import 'package:manager_app/pages/home/screen_home.dart';

class TermsAndConditionsPage extends StatelessWidget {
  final bool check;
  const TermsAndConditionsPage({super.key, required this.check});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Introduction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Welcome to our app. These terms and conditions outline the rules and regulations for the use of our app. By accessing this app, we assume you accept these terms and conditions. Do not continue to use the app if you do not agree to take all of the terms and conditions stated on this page.',
            ),
            const SizedBox(height: 16),
            const Text(
              'License',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unless otherwise stated, we own the intellectual property rights for all material on the app. All intellectual property rights are reserved. You may access this from the app for your own personal use subjected to restrictions set in these terms and conditions.',
            ),
            const SizedBox(height: 16),
            const Text(
              'User Content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'In these terms and conditions, "User Content" shall mean any audio, video text, images or other material you choose to display on this app. By displaying User Content, you grant us a non-exclusive, worldwide irrevocable, sub-licensable license to use, reproduce, adapt, publish, translate and distribute it in any and all media.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Limitations of liability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'In no event shall we, nor any of our officers, directors and employees, be liable to you for anything arising out of or in any way connected with your use of this app, whether such liability is under contract, tort or otherwise, and we, including our officers, directors and employees shall not be liable for any indirect, consequential or special liability arising out of or in any way related to your use of this app.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Changes to these terms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We reserve the right to revise these terms and conditions at any time as we see fit, and by using this app you are expected to review these terms on a regular basis.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions about these Terms and Conditions, You can contact us at: siyadsiyad016@gmail.com',
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (check) {
                    Navigator.pushReplacement(
                        context,
                        (MaterialPageRoute(
                            builder: (ctx) => const HomeScreen())));
                  } else {
                    Navigator.pop(context);
                  }
                },
                child:
                    const Text('Accept ', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
