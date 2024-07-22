// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

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
  for (int i = 0; i < teamBox.length; i++) {
    final existingTeam = teamBox.getAt(i);
    if (existingTeam != null && existingTeam.id == updatedTeam.id) {
      await teamBox.putAt(i, updatedTeam);
      break;
    }
  }

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
      await teamBox.putAt(i, team);
    }
  }

  teams.value = teamBox.values.toList();
  teams.notifyListeners();
}

Future<void> addTaskToTeam(int teamId, int taskId) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');

  final index = teamBox.values.toList().indexWhere((team) => team.id == teamId);

  if (index != -1) {
    final team = teamBox.getAt(index);

    team!.taskIds ??= [];
    team.taskIds!.add(taskId);

    await teamBox.putAt(index, team);
  }
}

Future<void> deleteTeamTaskId(TeamDetails team, int taskId) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');

  final index = teamBox.values.toList().indexWhere((t) => t.id == team.id);

  if (index != -1) {
    final updatedTeam = teamBox.getAt(index);

    if (updatedTeam != null && updatedTeam.taskIds != null) {
      updatedTeam.taskIds!.remove(taskId);
      await teamBox.putAt(index, updatedTeam);
    }
  }

  teams.value = teamBox.values.toList();
  teams.notifyListeners();
}
