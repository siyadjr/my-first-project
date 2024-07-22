// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/team_details_.dart';

ValueNotifier<List<Members>> memberPass = ValueNotifier([]);

Future<void> addMembers(Members value) async {
  final membersBox = await Hive.openBox<Members>('members_db');
  await membersBox.add(value);

  memberPass.value = membersBox.values.toList();
  memberPass.notifyListeners();
}

Future<List<Members>> getAllMembers([String? search]) async {
  final memberBox = await Hive.openBox<Members>('members_db');
  List<Members> allMembers = memberBox.values.toList();
  if (search != null && search.isNotEmpty) {
    allMembers = allMembers
        .where((member) =>
            member.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }
  return allMembers;
}

Future<void> deleteMembers(int index) async {
  final memberbox = await Hive.openBox<Members>('members_db');
  await memberbox.deleteAt(index);
  memberPass.value.removeAt(index);
  memberPass.notifyListeners();
}

Future<void> updateMember(Members updatedMember) async {
  final memberBox = await Hive.openBox<Members>('members_db');

  for (int i = 0; i < memberBox.length; i++) {
    final existingMember = memberBox.getAt(i);
    if (existingMember != null && existingMember.id == updatedMember.id) {
      await memberBox.putAt(i, updatedMember);
      break;
    }
  }
  memberPass.value.toList();
  memberPass.notifyListeners();
}

Future<List<Members>> getTeamMember(int id) async {
  final teamBox = Hive.box<TeamDetails>('teamdetails_db');
  final index = teamBox.values.toList().indexWhere((team) => team.id == id);
  final team = teamBox.getAt(index);
  final memberIds = team!.memberIds;
  final memberBox = Hive.box<Members>('members_db');
  List<Members> members = [];

  for (int id in memberIds!) {
    Members? member = memberBox.values.firstWhere(
      (member) => member.id == id,
    );
    if (member != null) {
      members.add(member);
    }
  }

  return members;
}
