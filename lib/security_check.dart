import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/sequrity_pass.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/screen_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckSecurityQuestion extends StatefulWidget {
  const CheckSecurityQuestion({Key? key}) : super(key: key);

  @override
  _CheckSecurityQuestionState createState() => _CheckSecurityQuestionState();
}

class _CheckSecurityQuestionState extends State<CheckSecurityQuestion> {
  final TextEditingController answerController = TextEditingController();
  bool isAnswerReady = false;
  String? securityQuestion;

  @override
  void initState() {
    super.initState();
    getSecurityQuestion();
  }

  Future<void> getSecurityQuestion() async {
    final securityBox = Hive.box<SequrityPass>('security_db');
    final securityPass = securityBox.getAt(0);
    setState(() {
      securityQuestion = securityPass?.question;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Check Security Question',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (securityQuestion != null)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    '${securityQuestion!}?',
                    style: GoogleFonts.anekDevanagari(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextFormField(
              controller: answerController,
              style: GoogleFonts.anekDevanagari(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Answer',
                labelStyle: GoogleFonts.anekDevanagari(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF1E88E5)),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10.0)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: () {
                getAnswer();
              },
              child: Text(
                'Login',
                style: GoogleFonts.anekDevanagari(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isAnswerReady)
              const Text(
                'The answer is ready!',
                style: TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> getAnswer() async {
    final securityBox = Hive.box<SequrityPass>('security_db');
    final securityPass = securityBox.getAt(0);
    final answer = securityPass?.answer?.toUpperCase();
    final enteredAnswer = answerController.text.toUpperCase();
    if (answer != enteredAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
          content: Center(
              child: Text(
            'Answer Is not Correct!!',
            style: GoogleFonts.aBeeZee(
                color: const Color.fromARGB(255, 255, 255, 255)),
          )),
        ),
      );
    } else {
      final sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(userlogged, true);
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => const HomeScreen()),
          (route) => false);
    }
  }
}
