import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/functins/easy_access/app_bar_widget.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/db/model/functins/easy_access/easy_functions.dart';
import 'package:manager_app/db/model/functins/event_db.dart';
import 'package:manager_app/pages/events/edit_events.dart';

class EventDetailsPage extends StatefulWidget {
  final EventModel event;

  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late EventModel currentEvent;

  @override
  void initState() {
    super.initState();
    currentEvent = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Event Details',
        bgColor: AppColors.getColor(AppColor.maincolor),
        titleColor: AppColors.getColor(AppColor.secondaryColor),
        leadingColor: AppColors.getColor(AppColor.secondaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => EditEvents(event: widget.event)));
            if (value != null) {
              setState(() {
                currentEvent = value;
              });
            }
          },
          color: AppColors.getColor(AppColor.secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentEvent.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getColor(AppColor.textColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${currentEvent.date}',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.getColor(AppColor.textColor)
                            .withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (currentEvent.photo!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(currentEvent.photo!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage(
                                'lib/assets/default_event_image.jpg'),
                            fit: BoxFit.cover,
                          ),
                          color: AppColors.getColor(AppColor.warmColor),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'Venue:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getColor(AppColor.textColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentEvent.venue,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.getColor(AppColor.textColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getColor(AppColor.textColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentEvent.eventDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.getColor(AppColor.textColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    _confirmDelete(widget.event);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.getColor(AppColor.secondaryColor),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Delete Event',
                    style: TextStyle(
                        color: AppColors.getColor(AppColor.primarycolor),
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(EventModel event) async {
    await confirmAndDelete(
      context,
      'Are you sure you want to delete this Event?',
      () async {
        EventDb().deleteEvent(
          event,
        );
        Navigator.pop(context, 1);
      },
    );
  }
}
