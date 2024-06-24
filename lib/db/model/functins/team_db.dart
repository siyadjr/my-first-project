// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/team_details_.dart';

ValueNotifier<List<TeamDetails>> teams = ValueNotifier([]);

Future<void> addTeamData(TeamDetails value) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  await teamBox.add(value);

  teams.notifyListeners();
}

Future<List<TeamDetails>> getTeamDetails([String? search]) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  if (search == null || search.isEmpty) {
    return teamBox.values.toList();
  } else {
    return teamBox.values
        .where((team) =>
            team.teamName!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
}

Future<void> deleteTeam(int index) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  await teamBox.deleteAt(index);

  teams.value = teamBox.values.toList();
  teams.notifyListeners();
}

Future<void> updatedTeam(TeamDetails updatedTeam, int index) async {
  final teamBox = await Hive.openBox<TeamDetails>('teamdetails_db');
  await teamBox.putAt(index, updatedTeam);

  teams.value = teamBox.values.toList();
  teams.notifyListeners();
}

Future<void> deleteTeamMemberId(int memberId) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  for (int i = 0; i < teamBox.length; i++) {
    final team = teamBox.getAt(i);
    if (team != null &&
        team.memberIds != null &&
        team.memberIds!.contains(memberId)) {
      team.memberIds!.remove(memberId);
      await teamBox.putAt(
          i, team); 
    }
  }

  teams.value = teamBox.values.toList();
  teams.notifyListeners();
}
