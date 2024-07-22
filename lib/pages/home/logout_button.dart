import 'package:flutter/material.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/authentication/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
          _showExitConfirmationDialog(context);
        },
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            ),
            TextButton(
              onPressed: () {
                _exitToApp(context);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _exitToApp(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(userlogged, false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const ScreenLogin()),
    );
  }
}
