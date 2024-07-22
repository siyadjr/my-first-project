import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/tasks_db.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/select_team_members.dart';

class AddTasks extends StatefulWidget {
  final TeamDetails team;

  const AddTasks({
    super.key,
    required this.team,
  });

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage;
  List<int> selectedMemberIds = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 121, 48, 111),
          title: const Text(
            'Add Task',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 121, 48, 111),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? IconButton(
                              onPressed: () {
                                _showImagePicker(context);
                              },
                              icon: const Icon(Icons.add_a_photo_outlined),
                            )
                          : null,
                    ),
                    TextButton(
                      onPressed: () {
                        _showImagePicker(context);
                      },
                      child: const Text(
                        'Add Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey, // Assigning form key here
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldPage(
                        controllerType: nameController,
                        labelText: 'Task Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter task Name';
                          }
                          return null;
                        },
                      ),
                      TextFormFieldPage(
                        controllerType: descriptionController,
                        labelText: 'Task Description',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter task description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No Date Chosen!'
                                  : 'Picked Date: ${_selectedDate!.toLocal()}'
                                      .split(' ')[0],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _presentDatePicker();
                            },
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Select Your Members'),
                          trailing:
                              const Icon(Icons.keyboard_arrow_right_rounded),
                          onTap: () async {
                            final List<int>? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => SelectTeamMembers(
                                  team: widget.team,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                selectedMemberIds.clear();
                                selectedMemberIds.addAll(result);
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveTaskDetails();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  _pickImageFromSource(1);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.photo_library),
              ),
              IconButton(
                onPressed: () {
                  _pickImageFromSource(0);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(int value) async {
    var pickedImage;
    if (value == 0) {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Image picking cancelled!')),
      ));
    }
  }

  void _saveTaskDetails() async {
    final taskName = nameController.text;
    final taskDescription = descriptionController.text;
    final int taskId = DateTime.now().millisecondsSinceEpoch;

    final imagePath = _selectedImage?.path ?? '';

    if (taskName.isNotEmpty &&
        taskDescription.isNotEmpty &&
        _selectedDate != null &&
        taskId != 0) {
      final task = TaskDetails(
        taskname: taskName,
        taskDescription: taskDescription,
        date: _selectedDate!.toIso8601String(),
        id: taskId,
        photo: imagePath,
        selectedMemberIds: selectedMemberIds,
      );

      await addTask(task, widget.team);
      
      Navigator.pop(context, 1);
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }
}
