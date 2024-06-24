import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/sequrity_pass.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/db/model/user_pass_name.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  late Box<UserDetails> userBox;
  late Box<SequrityPass> seqbox;
  late Box<TeamDetails> teambox;
  late Box<Members> memberBox;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    userBox = await Hive.openBox<UserDetails>('user_db');
    seqbox = await Hive.openBox<SequrityPass>('security_db');
    teambox = await Hive.openBox<TeamDetails>('teamdetails_db');
    memberBox = await Hive.openBox<Members>('members_db');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showDeleteConfirmationDialog();
      },
      child: const Text('Delete Account', style: TextStyle(color: Colors.red)),
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () async {
                await _deleteUser();
                Navigator.of(context).pop();
                _navigateToLogin();
              },
              child: const Text('Confirm', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser() async {
    await userBox.clear();
    await seqbox.clear();
    await teambox.clear();
    await memberBox.clear();
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool('user_logged', false);
    final signupPref = await SharedPreferences.getInstance();
    await signupPref.setBool('signUp', false);
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
}
