import 'package:flutter/material.dart';

import '../models/day.dart';

class DayButton extends StatelessWidget {
  const DayButton({required this.day, required this.onPressed, Key? key})
      : super(key: key);

  final Day day;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onPressed(day.id);
      },
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        minimumSize: Size.zero,
        padding: const EdgeInsets.all(10),
        backgroundColor: day.isSelected ? Theme.of(context).accentColor : null,
        //backgroundColor: Colors.blue
        //maximumSize: Size.fromWidth(20),
      ),
      child: Text(
        day.shortName,
        style: TextStyle(
            color:
                day.isSelected ? Colors.white : Theme.of(context).accentColor),
      ),
    );
  }
}
