import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/team_db.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/pages/folder_teams/details_team.dart';
import 'package:manager_app/pages/homescreen_widgets/search_bar.dart';

class TeamList extends StatefulWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  _TeamListState createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  Future<void> _fetchTeams() async {
    final teamsList = await getTeamDetails(_searchQuery);
    teams.value = teamsList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // color: Color.fromARGB(255, 2, 52, 55),
        child: Column(children: [
          SearchBarTeam(
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
              });
              _fetchTeams();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ValueListenableBuilder<List<TeamDetails>>(
                valueListenable: teams,
                builder: (context, teamDetailsList, child) {
                  return teamDetailsList.isEmpty
                      ? const Center(
                          child: Text("No teams"),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) {
                            final team = teamDetailsList[index];
                            return Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF005d63),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => DetailsTeam(
                                                team: team, index: index)));
                                  },
                                  leading: team.teamPhoto!.isEmpty
                                      ? const CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                              'lib/assets/team_default_image.jpg'))
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundColor: const Color.fromARGB(
                                              255, 67, 123, 132),
                                          backgroundImage:
                                              FileImage(File(team.teamPhoto!)),
                                        ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      confirmDelete(context, index);
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    team.teamName?.toUpperCase() ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(team.memberIds!.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.people_alt,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemCount: teamDetailsList.length,
                        );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> confirmDelete(BuildContext context, index) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to  delete?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteTeam(index);
                Navigator.pop(context);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
