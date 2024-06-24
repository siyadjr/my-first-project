import 'package:flutter/material.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _showExitConfirmationDialog(context);
      },
      icon: const Icon(
        Icons.exit_to_app,
        color: Colors.white,
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
                _exitToApp(context);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
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
