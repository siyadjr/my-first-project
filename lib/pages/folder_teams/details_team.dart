import 'package:flutter/material.dart';

import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/db/model/functins/easy_access/button_page.dart';
import 'package:manager_app/pages/folder_members/all_members.dart';
import 'package:manager_app/pages/folder_teams/edit_team.dart';
import 'package:manager_app/pages/folder_teams/point%20table/point_table_container.dart';
import 'package:manager_app/pages/folder_teams/task%20for%20teams/task_container.dart';
import 'package:manager_app/pages/folder_teams/team_all_members.dart';
import 'package:manager_app/pages/folder_teams/team_members.dart';
import 'package:manager_app/pages/folder_teams/team_name_container.dart';

class DetailsTeam extends StatefulWidget {
  final TeamDetails team;
  final int index;

  const DetailsTeam({super.key, required this.team, required this.index});

  @override
  _DetailsTeamState createState() => _DetailsTeamState();
}

class _DetailsTeamState extends State<DetailsTeam> {
  late TeamDetails team;

  @override
  void initState() {
    super.initState();
    team = widget.team;
  }

  void refreshTeamMembers() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 250, 254, 255),
          centerTitle: true,
          title: Text(
            '${team.teamName!.toUpperCase()} Details',
            style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final updatedTeam = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            EditTeam(team: team, index: widget.index)));
                if (updatedTeam != null) {
                  setState(() {
                    team = updatedTeam;
                    refreshTeamMembers(); // Call the refresh function
                  });
                }
              },
              icon: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TeamNameContainer(team: team),
                  const SizedBox(height: 20),
                  ButtonPage(
                      targetPage: TeamAllMembers(
                        team: team,
                      ),
                      buttonName: "Members"),
                  TeamMembers(
                    team: team,
                    onRefresh: refreshTeamMembers,
                  ),
                  const ButtonPage(
                      targetPage: AllMembers(), buttonName: 'Tasks'),
                  const TeamTaskContainer(),
                  const ButtonPage(
                      targetPage: AllMembers(), buttonName: 'Point Table'),
                  PointTableContainer(
                    team: team,
                    onRefresh: refreshTeamMembers,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
