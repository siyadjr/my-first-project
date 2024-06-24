import 'package:flutter/material.dart';

class TeamTaskContainer extends StatelessWidget {
  const TeamTaskContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.blue,
        height: 200,
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No Tasks'),
        ));
  }
}
