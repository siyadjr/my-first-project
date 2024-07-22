import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_app/db/model/event_model.dart';

typedef DeleteFunction = Future<void> Function();

Future<bool?> showConfirmDeleteDialog(
    BuildContext context, String message) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<void> confirmAndDelete(
    BuildContext context, String message, DeleteFunction deleteFunction) async {
  bool? confirmDelete = await showConfirmDeleteDialog(context, message);
  if (confirmDelete != null && confirmDelete) {
    await deleteFunction();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Center(child: Text('Item deleted'))),
    );
  }
}

void showFirstEventDialog(EventModel event, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Center(
          child: Text(
            'Upcoming Event',
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.photo != null && File(event.photo!).existsSync())
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(event.photo!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Text(
                'Event: ${event.title}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(
                    event.date,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(
                    event.venue,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                event.eventDescription,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

EventModel getNearestEvent(List<EventModel> events) {
  DateTime today = DateTime.now();
  events.sort((a, b) {
    DateTime dateA = DateFormat('yyyy-MMMM-dd').parse(a.date);
    DateTime dateB = DateFormat('yyyy-MMMM-dd').parse(b.date);
    return dateA.compareTo(dateB);
  });
  EventModel nearestEvent = events.firstWhere((event) {
    DateTime eventDate = DateFormat('yyyy-MMMM-dd').parse(event.date);
    return eventDate.isAfter(today) || eventDate.isAtSameMomentAs(today);
  }, orElse: () => events.first);
  return nearestEvent;
}
