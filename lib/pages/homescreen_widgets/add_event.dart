import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({super.key});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final _teamNameController = TextEditingController();

  final _dateController = TextEditingController();

  final _headingController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _venueController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 71, 162, 159),
          title: Text(
            'Add Events',
            style: GoogleFonts.jost(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 71, 162, 159),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_a_photo_outlined))),
                ),
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _teamNameController,
                        decoration: InputDecoration(
                            hintText: 'Event Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Event name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                addDate();
                              },
                              icon: Icon(Icons.calendar_month)),
                          labelText: 'Pick date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                          controller: _headingController,
                          decoration: InputDecoration(
                              hintText: 'Heading',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Date';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              hintText: 'Description',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Date';
                            }
                            return null;
                          }),
                      const SizedBox(height: 15),
                      TextFormField(
                          controller: _venueController,
                          decoration: InputDecoration(
                              hintText: 'Venue',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Date';
                            }
                            return null;
                          }),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
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

  Future<void> addDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }
}
