import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_app/pages/folder_members/add_members.dart';
import 'package:manager_app/pages/folder_members/list_members.dart';

class AllMembers extends StatefulWidget {
  const AllMembers({Key? key});

  @override
  State<AllMembers> createState() => _AllMembersState();
}

class _AllMembersState extends State<AllMembers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF005d63),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            'ALL Members',
            style: GoogleFonts.alef(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const ListMembers(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF005d63),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => const AddMembers()));
          },
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
    );
  }
}
