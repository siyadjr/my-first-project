import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:manager_app/db/model/member_details.dart';

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

Future<void> updateMember(Members updatedMember, index) async {
  final memberBox = await Hive.openBox<Members>('members_db');
  await memberBox.putAt(index, updatedMember);
  memberPass.notifyListeners();
  await memberBox.close();
}
