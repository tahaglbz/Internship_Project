import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final Widget? title;
  final bool centerTitle;
  final Color iconThemeColor;
  final List<Color> gradientColors;

  CustomAppBar({
    Key? key,
    required this.appBarHeight,
    this.automaticallyImplyLeading =
        true, // Default value to allow auto leading
    this.leading,
    this.title,
    this.centerTitle = true,
    this.iconThemeColor = Colors.white,
    this.gradientColors = const [
      Color.fromARGB(255, 5, 9, 237),
      Color.fromARGB(255, 8, 1, 134),
      Color.fromARGB(255, 5, 0, 74),
    ], // Default colors as specified
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        iconTheme: IconThemeData(color: iconThemeColor),
        automaticallyImplyLeading: automaticallyImplyLeading,
        elevation: 0,
        leading: leading,
        title: title,
        centerTitle: centerTitle,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradientColors,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
