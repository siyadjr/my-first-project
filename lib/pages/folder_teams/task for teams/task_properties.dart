import 'package:flutter/material.dart';

class TaskProperties extends StatefulWidget {
  final String textName;
  final String textValue;

  const TaskProperties(
      {super.key, required this.textName, required this.textValue});

  @override
  State<TaskProperties> createState() => _TaskPropertiesState();
}

class _TaskPropertiesState extends State<TaskProperties> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.textName}:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            Text(
              widget.textValue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
