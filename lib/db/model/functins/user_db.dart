import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/user_pass_name.dart';

ValueNotifier<List<UserDetails>> users = ValueNotifier([]);


Future<void> addUserData(UserDetails value) async {
  final userBox = Hive.box<UserDetails>('user_db');
  await userBox.add(value);
  users.value.add(value);
  for (var user in userBox.values) {
    print(user.name);
  }
}


