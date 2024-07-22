import 'package:flutter/material.dart';

enum AppColor {
  maincolor,
  secondaryColor,
  thirdcolor,
  textColor,
  warmColor,
  primarycolor,
}

class AppColors {
  static Color getColor(AppColor color) {
    switch (color) {
      case AppColor.maincolor:
        return const Color(0xFF006D74);
      case AppColor.secondaryColor:
        return Colors.white;
      case AppColor.thirdcolor:
        return const Color.fromARGB(255, 51, 150, 192);
      case AppColor.textColor:
        return Colors.black;
      case AppColor.warmColor:
        return const Color.fromARGB(255, 143, 216, 211);
      case AppColor.primarycolor:
        return Color.fromARGB(255, 142, 19, 30);
      default:
        return Colors.black;
    }
  }
}
