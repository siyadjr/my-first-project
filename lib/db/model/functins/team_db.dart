import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/team_details_.dart';

ValueNotifier<List<TeamDetails>> teams = ValueNotifier([]);

Future<void> addTeamData(TeamDetails value) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  await teamBox.add(value);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  teams.notifyListeners();
}

Future<List<TeamDetails>> getTeamDetails([String? search]) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  if (search == null || search.isEmpty) {
    return teamBox.values.toList();
  } else {
    // Filter teams based on the search parameter
    return teamBox.values.where((team) =>
        team.teamName!.toLowerCase().contains(search.toLowerCase())).toList();
  }
}

Future<void> deleteTeam(int index) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  await teamBox.deleteAt(index);
  teams.value.removeAt(index);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  teams.notifyListeners();
}
