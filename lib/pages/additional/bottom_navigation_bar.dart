// import 'package:flutter/material.dart';
// import 'package:manager_app/pages/folder_members/all_members.dart';
// import 'package:manager_app/pages/screen_home.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// class MyBottomNavigationBar extends StatefulWidget {
//   const MyBottomNavigationBar({super.key});

//   @override
//   State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
// }

// class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
//   int _selectedIndex = 0;
//   final List<Widget> _widgetOptions = <Widget>[
//     const HomeScreen(),
//     const AllMembers(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: _widgetOptions,
//         ),
//         bottomNavigationBar: SalomonBottomBar(
//           currentIndex: _selectedIndex,
//           onTap: (value) {
//             if (value != _selectedIndex) {
//               setState(() {
//                 _selectedIndex = value;
//               });
//             }
//           },
//           items: [
//             SalomonBottomBarItem(
//               icon: const Icon(Icons.home),
//               title: const Text("Home"),
//               selectedColor: const Color(0xFF005d63),
//             ),
//             SalomonBottomBarItem(
//               icon: const Icon(Icons.groups_2),
//               title: const Text("All Members"),
//               selectedColor: const Color(0xFF005d63),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
