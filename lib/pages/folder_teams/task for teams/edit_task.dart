import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/tasks_db.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/select_task_members.dart';

class EditTask extends StatefulWidget {
  final TaskDetails task;
  final TeamDetails team;


  const EditTask(
      {super.key,
      required this.task,
      required this.team,
     });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _newDate;
  File? _selectedImage;
  List<int> selectedMemberIds = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.taskname);
    _descriptionController =
        TextEditingController(text: widget.task.taskDescription);
    selectedMemberIds = widget.task.selectedMemberIds ?? [];
    _newDate = widget.task.date ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Task'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : widget.task.photo != null &&
                                    widget.task.photo!.isNotEmpty
                                ? FileImage(File(widget.task.photo!))
                                : const AssetImage(
                                        'lib/assets/default_task.jpg')
                                    as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      color: const Color(0xFFCED9E3),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        _showImagePicker(context);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormFieldPage(
                        controllerType: _nameController,
                        labelText: 'New task name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormFieldPage(
                        controllerType: _descriptionController,
                        labelText: 'New Description',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _newDate.isEmpty
                                  ? 'No Date Chosen!'
                                  : 'Picked Date: $_newDate'.split(' ')[0],
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
                      Card(
                        child: ListTile(
                          title: const Text('Edit Your Members'),
                          trailing:
                              const Icon(Icons.keyboard_arrow_right_rounded),
                          onTap: () async {
                            final List<int>? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => SelectTaskMembers(
                                  task: widget.task,
                                  team: widget.team,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                selectedMemberIds = result;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveUpdated();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUpdated() async {
    final updatedName = _nameController.text;
    final updatedAbout = _descriptionController.text;
    final updatedImage =
        _selectedImage == null ? widget.task.photo! : _selectedImage!.path;
    final updatedNewDate = _newDate;
    final newTask = TaskDetails(
      taskname: updatedName,
      taskDescription: updatedAbout,
      photo: updatedImage,
      selectedMemberIds: selectedMemberIds,
      date: updatedNewDate,
      id: widget.task.id,
    );
    
    await editTask(newTask);
    Navigator.pop(context, newTask);
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
                  _pickImageFromSource(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.photo_library),
              ),
              IconButton(
                onPressed: () {
                  _pickImageFromSource(ImageSource.camera);
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

  Future<void> _pickImageFromSource(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

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
        _newDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    });
  }
}
