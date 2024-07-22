import 'package:flutter/material.dart';
import 'package:manager_app/pages/home/homescreen_widgets/settings.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const Settings()));
        },
        icon: const Icon(
          Icons.settings,
          color: Colors.white,
        ));
  }
}
