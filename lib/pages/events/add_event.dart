import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/functins/easy_access/app_bar_widget.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/event_db.dart';
import 'package:manager_app/pages/folder_teams/add_team_container.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({super.key});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final _eventTitleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  String? _selectedDate;
  File? _selectedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          titleColor: AppColors.getColor(AppColor.secondaryColor),
          leadingColor: AppColors.getColor(AppColor.secondaryColor),
          bgColor: AppColors.getColor(AppColor.thirdcolor),
          centerTitle: true,
          title: 'Add Events',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AddTeamContainer(
                selectedImage: _selectedImage,
                onImageSelected: _setImage,
                color: AppColors.getColor(AppColor.thirdcolor),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      TextFormFieldPage(
                        prefixIcon: const Icon(Icons.event_note),
                        controllerType: _eventTitleController,
                        labelText: 'Event Title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No Date Chosen!'
                                  : 'Picked Date: $_selectedDate',
                            ),
                          ),
                          TextButton(
                            onPressed: _presentDatePicker,
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TextFormFieldPage(
                        maxLine: 3,
                        controllerType: _descriptionController,
                        labelText: 'Description',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      TextFormFieldPage(
                        prefixIcon: const Icon(Icons.location_on),
                        controllerType: _venueController,
                        labelText: 'Venue',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter venue';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveEvent();
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

  Future<void> _saveEvent() async {
    final newEvent = EventModel(
        id: DateTime.now().millisecondsSinceEpoch,
        eventDescription: _descriptionController.text,
        date: _selectedDate!,
        title: _eventTitleController.text,
        venue: _venueController.text,
        photo: _selectedImage?.path ?? '');
    await EventDb().saveEvent(newEvent);
    Navigator.pop(context, newEvent);
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = DateFormat('dd-MMMM-yyyy').format(pickedDate);
          _dateController.text = _selectedDate!;
        });
      }
    });
  }

  void _setImage(File selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
  }
}
