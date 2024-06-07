import 'package:flutter/material.dart';
import 'package:manager_app/pages/folder_members/all_members.dart';


class AddMemberIcon extends StatelessWidget {
  const AddMemberIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const AllMembers()));
        },
        icon: const Icon(
          Icons.person_add_alt_1_rounded,
          color: Colors.white,
        ));
  }
}
