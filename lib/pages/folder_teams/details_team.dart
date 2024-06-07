import 'package:flutter/material.dart';
import 'dart:io';
import 'package:manager_app/db/model/team_details_.dart';

class DetailsTeam extends StatelessWidget {
  final TeamDetails team;

  const DetailsTeam({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text(
            team.teamName ?? 'No Team Name',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              team.teamPhoto == null || team.teamPhoto!.isEmpty
                  ? const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('lib/assets/team_default_image.jpg'),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(team.teamPhoto!)),
                    ),
              const SizedBox(height: 16),
              Text(
                team.teamName ?? 'No Team Name',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Members: ${team.members?.length ?? 0}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Description: ${team.teamAbout ?? 'No Description'}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
