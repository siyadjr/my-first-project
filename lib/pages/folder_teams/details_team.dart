import 'package:flutter/material.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';

import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/db/model/functins/easy_access/button_page.dart';
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

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.getColor(AppColor.secondaryColor),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.getColor(AppColor.secondaryColor),
          ),
          backgroundColor: AppColors.getColor(AppColor.maincolor),
          centerTitle: true,
          title: Text(
            '${team.teamName!.toUpperCase()} Details',
            style: TextStyle(
                color: AppColors.getColor(AppColor.secondaryColor),
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
                    refresh();
                  });
                }
              },
              icon: Icon(
                Icons.edit,
                color: AppColors.getColor(AppColor.secondaryColor),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
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
                    onRefresh: refresh,
                  ),
                  TeamTaskContainer(
                    team: widget.team,
                    onRefresh: refresh,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => PointTableContainer(
                                      team: team, onRefresh: refresh)));
                        },
                        child: Image.asset(
                          'lib/assets/point_system_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
