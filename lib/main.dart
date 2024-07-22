
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/db/model/sequrity_pass.dart';
import 'package:manager_app/db/model/task_details.dart';
import 'package:manager_app/db/model/team_details_.dart';
import 'package:manager_app/db/model/user_pass_name.dart';
import 'package:manager_app/pages/authentication/splashscreen.dart';

const userlogged = "userlogged";
const compleatSignup = "signUp";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Hive.initFlutter();
  Hive.registerAdapter(UserDetailsAdapter());
  Hive.registerAdapter(TeamDetailsAdapter());
  Hive.registerAdapter(SequrityPassAdapter());
  Hive.registerAdapter(MembersAdapter());
  Hive.registerAdapter(TaskDetailsAdapter());
  Hive.registerAdapter(EventModelAdapter());

  await Hive.openBox<Members>('members_db');
  await Hive.openBox<SequrityPass>('security_db');
  await Hive.openBox<UserDetails>('user_db');
  await Hive.openBox<TeamDetails>('teamdetails_db');
  await Hive.openBox<TaskDetails>('task_db');
  await Hive.openBox<EventModel>('event_db');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
