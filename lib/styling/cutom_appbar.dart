import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  //const CustomAppBar({Key? key}) : super(key: key);

  final AppBar appBar;

  CustomAppBar()
      : appBar = AppBar(
          title: const Text('Set Up Your Checker'),
        );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      child: appBar,
    );
  }

  @override
  Size get preferredSize => appBar.preferredSize;
}
