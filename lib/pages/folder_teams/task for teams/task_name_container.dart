import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_app/db/model/task_details.dart';

class TaskNameContainer extends StatefulWidget {
  final TaskDetails task;
  const TaskNameContainer({super.key,required this.task});

  @override
  State<TaskNameContainer> createState() => _TaskNameContainerState();
}

class _TaskNameContainerState extends State<TaskNameContainer> {
  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: widget.task.photo == null ||
                          widget.task.photo!.isEmpty
                      ? const AssetImage('lib/assets/default_task.jpg')
                      : FileImage(File(widget.task.photo!))
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.taskname.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF005D63),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.task.taskDescription,
                    style: const TextStyle(
                      color: Color(0xFF005D63),
                      fontSize: 16,
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
}
