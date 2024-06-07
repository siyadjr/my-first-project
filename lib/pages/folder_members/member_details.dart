import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/pages/folder_members/edit_member.dart';

class DetailsMember extends StatelessWidget {
  final Members member;
  final int index;
  const DetailsMember({required this.member, super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Color(0xFF005d63),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => EditMembers(
                                        member: member, index: index)));
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ],
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          member.photo != null && member.photo!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 90,
                                  backgroundImage:
                                      FileImage(File(member.photo!)),
                                )
                              : const CircleAvatar(
                                  radius: 90,
                                  backgroundImage: AssetImage(
                                      'lib/assets/default_avatar_member.jpg'),
                                ),
                          const SizedBox(height: 10),
                          Text(
                            member.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFCED9E3)),
                      child: Center(
                        child: Text(
                          member.role,
                          style: GoogleFonts.anekDevanagari(
                            color: const Color(0xFF005d63),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFCED9E3)),
                      child: Center(
                        child: Text(
                          member.strength,
                          style: GoogleFonts.anekDevanagari(
                            color: const Color(0xFF005d63),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFCED9E3)),
                      child: Center(
                        child: Text(
                          member.phone,
                          style: GoogleFonts.anekDevanagari(
                            color: const Color(0xFF005d63),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
