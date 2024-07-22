import 'package:flutter/material.dart';
import 'package:manager_app/db/model/settings.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/pages/events/delete_account.dart';
import 'package:manager_app/pages/home/logout_button.dart';
import 'package:manager_app/pages/settings/about_us.dart';
import 'package:manager_app/pages/settings/privacy_and_policy.dart';
import 'package:manager_app/pages/settings/terms_and_conditions.dart';

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
        title: 'About us',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const AboutUsPage(),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: AppColors.getColor(AppColor.secondaryColor)),
        title: Text(
          'Settings',
          style: TextStyle(color: AppColors.getColor(AppColor.secondaryColor)),
        ),
        centerTitle: true,
        backgroundColor: AppColors.getColor(AppColor.maincolor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
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
            const LogoutButton(),
            const DeleteAccount()
          ],
        ),
      ),
    );
  }
}
