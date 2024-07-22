import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/user_pass_name.dart';
import 'package:manager_app/pages/authentication/securities/security_qstn.dart';
import 'package:manager_app/pages/settings/terms_and_conditions.dart';
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

  bool _isSecurityQuestionSet = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getColor(AppColor.secondaryColor),
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'lib/assets/_ac218dd3-d8e0-40f8-b49a-230435367a7b.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormFieldPage(
                            controllerType: nameController,
                            labelText: 'Username',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                            buttonAction: (value) {
                              setState(() {
                                _validateForm();
                              });
                            },
                          ),
                          TextFormFieldPage(
                            maxLine: 1,
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
                            obscureText: true,
                          ),
                          TextFormFieldPage(
                            maxLine: 1,
                            controllerType: confirmpassController,
                            labelText: 'Confirm Password',
                            validator: (value) {
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            buttonAction: (value) {
                              setState(() {
                                _validateForm();
                              });
                            },
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),
                          if (!_isSecurityQuestionSet)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    final value = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => SecurityPage(),
                                      ),
                                    );
                                    if (value != null && value == true) {
                                      setState(() {
                                        _isSecurityQuestionSet = true;
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Set Security Question',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (ctx) => const TermsAndConditionsPage(
                  check: true,
                )),
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
