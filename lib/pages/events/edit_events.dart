import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/functins/easy_access/text_formfield.dart';
import 'package:manager_app/db/model/functins/event_db.dart';

class EditEvents extends StatefulWidget {
  final EventModel event;

  const EditEvents({super.key, required this.event});

  @override
  State<EditEvents> createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvents> {
  late TextEditingController _nameController;
  late TextEditingController _venueController;
  late TextEditingController _descriptionController;
  late String _newDate;
  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.title);
    _venueController = TextEditingController(text: widget.event.venue);
    _descriptionController =
        TextEditingController(text: widget.event.eventDescription);
    _newDate = widget.event.date;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Event'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : widget.event.photo != null &&
                                      widget.event.photo!.isNotEmpty
                                  ? FileImage(File(widget.event.photo!))
                                  : const AssetImage(
                                          'lib/assets/default_event_image.jpg')
                                      as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: FloatingActionButton(
                        onPressed: () => _showImagePicker(context),
                        mini: true,
                        child: const Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormFieldPage(
                        controllerType: _nameController,
                        labelText: 'Event Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event name';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _newDate.isEmpty
                                  ? 'No Date Chosen!'
                                  : 'Picked Date: $_newDate',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _presentDatePicker,
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormFieldPage(
                        controllerType: _venueController,
                        labelText: 'Event Venue',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event venue';
                          }
                          return null;
                        },
                      ),
                      TextFormFieldPage(
                        controllerType: _descriptionController,
                        labelText: 'Event Description',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveUpdated();
                    }
                  },
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveUpdated() async {
    final updatedName = _nameController.text;
    final updatedDate = _newDate;
    final updatedVenue = _venueController.text;
    final updatedDescription = _descriptionController.text;
    final updatedImage =
        _selectedImage == null ? widget.event.photo! : _selectedImage!.path;
    final newEvent = EventModel(
      title: updatedName,
      date: updatedDate,
      venue: updatedVenue,
      eventDescription: updatedDescription,
      photo: updatedImage,
      id: widget.event.id,
    );

    await EventDb().editEvent(widget.event.id, newEvent);
    Navigator.pop(context, newEvent);
  }

  Future<void> _showImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _pickImageFromSource(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.photo_library),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: () {
                    _pickImageFromSource(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.camera_alt),
                  iconSize: 40,
                ),
              ],
            ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Image picking cancelled!')),
        ),
      );
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
        _newDate = DateFormat('dd-MMMM-yyyy').format(pickedDate);
      });
    });
  }
}
