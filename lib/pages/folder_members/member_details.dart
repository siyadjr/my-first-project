import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_app/db/model/member_details.dart';
import 'package:manager_app/pages/folder_members/edit_member.dart';

class DetailsMember extends StatefulWidget {
  final Members member;
  final int index;

  const DetailsMember({
    Key? key,
    required this.member,
    required this.index,
  }) : super(key: key);

  @override
  State<DetailsMember> createState() => _DetailsMemberState();
}

class _DetailsMemberState extends State<DetailsMember> {
  late Members memberData;

  @override
  void initState() {
    super.initState();
    memberData = widget.member;
  }

  @override
  Widget build(BuildContext context) {
    print(memberData.id);
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
                            Navigator.pop(context, 1);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final updatedMember = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => EditMembers(
                                  member: memberData,
                                  index: widget.index,
                                ),
                              ),
                            );
                            if (updatedMember != null) {
                              setState(() {
                                memberData = updatedMember;
                              });
                            }
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ],
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          memberData.photo != null &&
                                  memberData.photo!.isNotEmpty
                              ? CircleAvatar(
                                  radius: 90,
                                  backgroundImage:
                                      FileImage(File(memberData.photo!)),
                                )
                              : const CircleAvatar(
                                  radius: 90,
                                  backgroundImage: AssetImage(
                                      'lib/assets/default_avatar_member.jpg'),
                                ),
                          const SizedBox(height: 10),
                          Text(
                            memberData.name.toUpperCase(),
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
                    buildDetailContainer(
                      label: 'Role',
                      value: memberData.role,
                    ),
                    const SizedBox(height: 20),
                    buildDetailContainer(
                      label: 'Strength',
                      value: memberData.strength,
                    ),
                    const SizedBox(height: 20),
                    buildDetailContainer(
                      label: 'Phone',
                      value: memberData.phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailContainer({required String label, required String value}) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFCED9E3),
      ),
      child: Center(
        child: Text(
          value,
          style: GoogleFonts.anekDevanagari(
            color: const Color(0xFF005d63),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
