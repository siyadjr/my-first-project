import 'package:flutter/material.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/screen_home.dart';
import 'package:manager_app/pages/screen_login.dart';
import 'package:manager_app/pages/signup_screen.dart';
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
    checkLogged();
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
                      text: 'MANGER',
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

  void toLoginScreen() {
    Future.delayed(const Duration(seconds: 3), () async {
      final _pref = await SharedPreferences.getInstance();
      final _signup = _pref.getBool(compleatSignup);
      if (_signup == null || _signup == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const ScreenLogin()));
      }
    });
  }

  Future<void> checkLogged() async {
    final _sharedPref = await SharedPreferences.getInstance();
    final _loggedin = _sharedPref.getBool(userlogged);
    if (_loggedin == null || _loggedin == false) {
      toLoginScreen();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
    }
  }
}
