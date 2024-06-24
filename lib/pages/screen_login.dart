import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/sequrity_pass.dart';
import 'package:manager_app/db/model/user_pass_name.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/screen_home.dart';
import 'package:manager_app/security_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  bool check = false;
  late Future<void> _securityFuture;

  @override
  void initState() {
    super.initState();
    _securityFuture = checkSecurity();
  }

  Future<void> checkSecurity() async {
    final value = await Hive.openBox<SequrityPass>('security_db');
    setState(() {
      check = value.values.isNotEmpty;
    });
  }

  bool _obscureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  void _validateForm() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'lib/assets/_ac218dd3-d8e0-40f8-b49a-230435367a7b.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        shadows: [
                          const Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: FutureBuilder<void>(
                      future: _securityFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextFormFieldPage(
                                    controllerType: nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a username';
                                      }
                                      return null;
                                    },
                                    labelText: 'name'),
                                const SizedBox(height: 20),
                                TextFormFieldPage(
                                  controllerType: passwordController,
                                  labelText: 'Password',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    return null;
                                  },
                                  buttonAction: (value) {
                                    setState(() {
                                      _validateForm();
                                    });
                                  },
                                  obscureText: _obscureText,
                                ),
                                const SizedBox(height: 10),
                                if (check)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: const Text('Forgotten password'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const CheckSecurityQuestion()));
                                        },
                                      )
                                    ],
                                  ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      checkLogin();
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkLogin() async {
    final enteredName = nameController.text;
    final enteredPass = passwordController.text;
    final userBox = await Hive.openBox<UserDetails>('user_db');
    UserDetails? storedUserData;
    try {
      storedUserData = userBox.values.firstWhere(
        (user) =>
            user                                                                                                                                                                                                                                                                                                                                                                                                                                                        .name.toUpperCase() == enteredName.toUpperCase() &&
            user.password.toUpperCase() == enteredPass.toUpperCase(),
      );
    } catch (e) {
      storedUserData = null;
    }
    await userBox.close();
    if (storedUserData != null) {
      print('Credentials are correct. Navigating to HomeScreen...');

      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setBool(userlogged, true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
              child: Text(
            'Username and Password isn\'t correct',
            style: GoogleFonts.aBeeZee(
                color: const Color.fromARGB(255, 255, 255, 255)),
          )),
        ),
      );
    }
  }
}
