import 'package:flutter/material.dart';
import 'package:manager_app/pages/settings/privacy_and_policy.dart';
import 'package:manager_app/pages/settings/terms_and_conditions.dart';

class SettingsIcons {
  final String title;
  final VoidCallback onTap;

  SettingsIcons({
    required this.title,
    required this.onTap,
  });
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingsIcons> drawerData = [
      SettingsIcons(
        title: 'Privacy and Policy',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const PrivacyPolicyPage()),
          );
        },
      ),
      SettingsIcons(
        title: 'Version',
        onTap: () {
          // Handle version information or navigation if needed
        },
      ),
      SettingsIcons(
        title: 'Terms and Conditions',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const TermsAndConditionsPage(check: false),
            ),
          );
        },
      ),
      SettingsIcons(
        title: 'Feedback',
        onTap: () {
          // Handle feedback or navigation if needed
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: drawerData.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      drawerData[index].title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: drawerData[index].onTap,
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Handle logout logic
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: const Text(
                  'Delete Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Handle delete account logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
