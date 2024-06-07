import 'package:flutter/material.dart';
import 'package:manager_app/pages/homescreen_widgets/add_event.dart';
import 'package:google_fonts/google_fonts.dart';

class EventContainer extends StatelessWidget {
  const EventContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const AddEvents()));
                    },
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF005d63),
                      size: 26,
                    ),
                  ),
                  Text(
                    'Upcoming Events',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(height: 4),
              const SizedBox(height: 4),
              const Text(
                'No events scheduled',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All Events',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const AddEvents()));
                    },
                    child: const Text(
                      'Add Events',
                      style: TextStyle(
                        color: Colors.blue,
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
