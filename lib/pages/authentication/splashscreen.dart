// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/authentication/screen_login.dart';
import 'package:manager_app/pages/authentication/signup_screen.dart';
import 'package:manager_app/pages/home/screen_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      checkLogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/Manager logo copy.png',
                height: 200,
                width: 200,
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Manage Your Team With ',
                    ),
                    TextSpan(
                      text: 'Gestio',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void toLoginScreen() async {
    final pref = await SharedPreferences.getInstance();
    final signup = pref.getBool(compleatSignup);
    if (signup == null || signup == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const ScreenLogin()),
      );
    }
  }

  Future<void> checkLogged() async {
    final sharedPref = await SharedPreferences.getInstance();
    final loggedin = sharedPref.getBool(userlogged);
    if (loggedin == null || loggedin == false) {
      toLoginScreen();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
      );
    }
  }
}
