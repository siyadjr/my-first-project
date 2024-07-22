import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/db/model/functins/event_db.dart';
import 'package:manager_app/pages/events/all_events.dart';
import 'package:manager_app/pages/events/add_event.dart';
import 'package:manager_app/pages/events/all_event_containers.dart';
import 'package:manager_app/pages/events/event_details.dart';

class EventContainer extends StatefulWidget {
  const EventContainer({super.key});

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final fetchedEvents = await EventDb().getAllEvents();
    if (mounted) {
      setState(() {
        events = fetchedEvents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      final newEvent = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AddEvents(),
                        ),
                      );
                      if (newEvent != null) {
                        setState(() {
                          events.add(newEvent);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.event,
                      color: AppColors.getColor(AppColor.thirdcolor),
                      size: 28,
                    ),
                  ),
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (events.isEmpty)
                const Text(
                  'No events scheduled',
                  style: TextStyle(fontSize: 14),
                )
              else
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return GestureDetector(
                        onTap: () async {
                          final value = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => EventDetailsPage(event: event),
                            ),
                          );
                          if (value != null) {
                            fetchEvents();
                          }
                        },
                        child: AllEventContainers(event: event),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AllEvents(),
                        ),
                      );
                      if (value != null) {
                        fetchEvents();
                      }
                    },
                    child: Text(
                      'View All Events',
                      style: TextStyle(
                        color: AppColors.getColor(AppColor.thirdcolor),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AddEvents(),
                        ),
                      );
                      if (value != null) {
                        fetchEvents();
                      }
                    },
                    child: Text(
                      'Add Events',
                      style: TextStyle(
                        color: AppColors.getColor(AppColor.thirdcolor),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
