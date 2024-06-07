import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/user_pass_name.dart';
import 'package:manager_app/pages/screen_home.dart';
import 'package:manager_app/security_qstn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void _validateForm() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _isSecurityQuestionSet = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Let\'s Start Your Journey',
                    style: GoogleFonts.aBeeZee(
                      color: const Color.fromARGB(255, 255, 255, 255),
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
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    autovalidateMode:
                        AutovalidateMode.onUserInteraction, // Add this line
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _validateForm();
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _validateForm();
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: confirmpassController,
                          obscureText: _obscureText2,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText2 = !_obscureText2;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!_isSecurityQuestionSet)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _isSecurityQuestionSet = true;
                                  });

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => SecurityPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Set Security Question',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_isSecurityQuestionSet) {
                                signup();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Center(
                                      child: Text(
                                        'Please set a security question first',
                                        style: GoogleFonts.aBeeZee(
                                            color: Colors.red),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signup() async {
    final enteredName = nameController.text;
    final enteredPass = passwordController.text;
    final confirmPass = confirmpassController.text;

    if (confirmPass == enteredPass) {
      final userBox = await Hive.openBox<UserDetails>('user_db');
      final userData = UserDetails(name: enteredName, password: enteredPass);
      await userBox.add(userData);
      await userBox.close();

      final signupPref = await SharedPreferences.getInstance();
      await signupPref.setBool('signUp', true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('userLogged', true);
      print('User data added: ${userData.name}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Passwords do not match',
              style: GoogleFonts.aBeeZee(color: Colors.red),
            ),
          ),
        ),
      );
    }
  }
}
