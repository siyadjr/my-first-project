import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/functins/easy_access/easy_functions.dart';
import 'package:manager_app/db/model/user_pass_name.dart';
import 'package:manager_app/pages/folder_members/add_members_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_app/pages/folder_teams/add_team.dart';
import 'package:manager_app/pages/events/event_container.dart';
import 'package:manager_app/pages/home/homescreen_widgets/settings_button.dart';
import 'package:manager_app/pages/home/homescreen_widgets/team_list.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/functins/event_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final fetchedEvents = await EventDb().getAllEvents();
    setState(() {
      events = fetchedEvents;
    });
    if (events.isNotEmpty) {
      EventModel nearestEvent = getNearestEvent(events);
      showFirstEventDialog(nearestEvent, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetails>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userData = snapshot.data!;
          return _buildScreen(context, userData);
        }
      },
    );
  }

  Future<UserDetails> getUserData() async {
    final userBox = await Hive.openBox<UserDetails>('user_db');
    return userBox.getAt(0)!;
  }

  Widget _buildScreen(BuildContext context, UserDetails userData) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF005d63),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
              ),
              expandedHeight: 350,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Gestio',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
                background: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Welcome',
                              style: GoogleFonts.alef(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Row(
                              children: [AddMemberIcon(), SettingsButton()],
                            )
                          ],
                        ),
                        Text(
                          userData.name.toUpperCase(),
                          style: GoogleFonts.alef(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const Center(
                          child: SizedBox(
                            child: EventContainer(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverFillRemaining(
              child: Column(
                children: [
                  SizedBox(height: 35),
                  Expanded(child: TeamList()),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF005d63),
          child: const Icon(
            Icons.group_add_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => const AddTeam()),
            );
          },
        ),
      ),
    );
  }
}
