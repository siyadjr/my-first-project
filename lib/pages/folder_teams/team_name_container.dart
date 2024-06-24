import 'package:flutter/material.dart';
import 'dart:io';
import 'package:manager_app/db/model/team_details_.dart';

class TeamNameContainer extends StatefulWidget {
  final TeamDetails team;

  const TeamNameContainer({Key? key, required this.team}) : super(key: key);

  @override
  State<TeamNameContainer> createState() => _TeamNameContainerState();
}

class _TeamNameContainerState extends State<TeamNameContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 180,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: widget.team.teamPhoto == null ||
                        widget.team.teamPhoto!.isEmpty
                    ? const AssetImage('lib/assets/team_default_image.jpg')
                    : FileImage(File(widget.team.teamPhoto!)) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.team.teamName!.toUpperCase(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.team.teamAbout!,
                  style: const TextStyle(
                    color: Color.fromARGB(179, 0, 0, 0),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
