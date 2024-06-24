import 'package:flutter/material.dart';

class ButtonPage extends StatelessWidget {
  final Widget targetPage;
  final String buttonName;

  const ButtonPage({
    Key? key,
    required this.targetPage,
    required this.buttonName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 85, 
      height: 30,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 171, 20, 20),
          padding: EdgeInsets.zero, // Remove padding to fit text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          buttonName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12, // Reduce font size to fit within the button
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
