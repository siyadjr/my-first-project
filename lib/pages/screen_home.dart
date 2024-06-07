import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/drawer.dart';
import 'package:manager_app/db/model/user_pass_name.dart';
import 'package:manager_app/main.dart';
import 'package:manager_app/pages/add_team.dart';
import 'package:manager_app/pages/folder_members/add_members_icon.dart';
import 'package:manager_app/pages/homescreen_widgets/delete_account.dart';
import 'package:manager_app/pages/homescreen_widgets/event_container.dart';
import 'package:manager_app/pages/homescreen_widgets/team_list.dart';
import 'package:manager_app/pages/screen_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DrawerDetails> drawerdata = [
    DrawerDetails(title: 'Privacy and Policy', trailing: ''),
    DrawerDetails(title: 'Version', trailing: '1.0.2'),
    DrawerDetails(title: 'Terms and Conditions', trailing: ''),
    DrawerDetails(title: 'Feedback', trailing: ''),
  ];

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
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              const DrawerHeader(
                child: Center(
                  child: Text(
                    'About',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: drawerdata.length + 1,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    if (index < drawerdata.length) {
                      return ListTile(
                        title: Text(drawerdata[index].title),
                        trailing: Text(drawerdata[index].trailing),
                      );
                    } else {
                      return const ListTile(
                        title: DeleteAccount(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
                    'Manager',
                    style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
                background: Padding(
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
                          Row(
                            children: [
                              const AddMemberIcon(),
                              IconButton(
                                onPressed: () {
                                  _showExitConfirmationDialog(context);
                                },
                                icon: const Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
        // bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                _exitToApp(context);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _exitToApp(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(userlogged, false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctx) => const ScreenLogin()),
    );
  }
}
