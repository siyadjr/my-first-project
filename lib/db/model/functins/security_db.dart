import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/sequrity_pass.dart';

ValueNotifier<List<SequrityPass>> userspass = ValueNotifier([]);

Future<void> addSecuritypass(SequrityPass value) async {
  final securitybox = Hive.box<SequrityPass>('security_db');
  await securitybox.add(value);
  userspass.value.add(value);
}
