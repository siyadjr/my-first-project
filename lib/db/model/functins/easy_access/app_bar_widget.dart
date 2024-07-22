import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  final Widget? trailing;
  final Widget? leading;
  final Color bgColor;
  final Color titleColor;
  final Color? leadingColor;

  const AppBarWidget({
    super.key,
    required this.title,
    this.centerTitle,
    this.trailing,
    this.leading,
    required this.bgColor,
    required this.titleColor,
    this.leadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
    
      iconTheme: IconThemeData(color: leadingColor),
      backgroundColor: bgColor,
      title: Text(
        title,
        style: TextStyle(color: titleColor),
        
      ),
      centerTitle: centerTitle,
      actions: trailing != null ? [trailing!] : null,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
