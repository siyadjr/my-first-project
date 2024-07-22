import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/functins/easy_access/app_bar_widget.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';
import 'package:manager_app/db/model/functins/easy_access/easy_functions.dart';
import 'package:manager_app/db/model/functins/event_db.dart';
import 'package:manager_app/pages/events/edit_events.dart';
import 'package:manager_app/pages/events/event_details.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
  List<EventModel> events = [];
  bool isSortedAscending = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final fetchedEvent = await EventDb().getAllEvents();
    setState(() {
      events = fetchedEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getColor(AppColor.maincolor),
      appBar: AppBarWidget(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getColor(AppColor.secondaryColor),
          ),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        bgColor: AppColors.getColor(AppColor.maincolor),
        title: 'All Events',
        titleColor: AppColors.getColor(AppColor.secondaryColor),
        trailing: IconButton(
          icon: Icon(
            isSortedAscending ? Icons.sort : Icons.short_text_outlined,
            color: AppColors.getColor(AppColor.secondaryColor),
          ),
          onPressed: sortEvents,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: events.isEmpty
            ? Center(
                child: Text(
                  'No events found',
                  style: TextStyle(
                      color: AppColors.getColor(AppColor.secondaryColor)),
                ),
              )
            : ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];

                  return Card(
                    color: AppColors.getColor(AppColor.secondaryColor),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(
                        event.title.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.getColor(AppColor.thirdcolor),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            event.eventDescription,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.getColor(AppColor.textColor),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color:
                                      AppColors.getColor(AppColor.textColor)),
                              const SizedBox(width: 5),
                              Text(
                                event.date,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditEvents(event: event),
                              ),
                            ).then((_) => fetchEvents());
                          } else if (value == 'Delete') {
                            _confirmDelete(event);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'Edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        final value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventDetailsPage(event: event),
                          ),
                        );
                        if (value != null) {
                          fetchEvents(); // Fetch events only if needed
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void sortEvents() {
    setState(() {
      events.sort((a, b) {
        DateTime dateA = parseDate(a.date);
        DateTime dateB = parseDate(b.date);
        return isSortedAscending
            ? dateA.compareTo(dateB)
            : dateB.compareTo(dateA);
      });
      isSortedAscending = !isSortedAscending;
    });
  }

  DateTime parseDate(String dateString) {
    return DateFormat('dd-MMMM-yyyy').parse(dateString);
  }

  Future<void> _confirmDelete(EventModel event) async {
    await confirmAndDelete(
      context,
      'Are you sure you want to delete this Event?',
      () async {
        EventDb().deleteEvent(
          event,
        );
        setState(() {
          fetchEvents();
        });
      },
    );
  }
}
