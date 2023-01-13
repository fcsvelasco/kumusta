import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import './my_custom_icons_icons.dart';
import '../widgets/page_heading.dart';

const COLOR = [
  Color.fromRGBO(254, 222, 190, 1),
  Color.fromRGBO(219, 243, 250, 0.5),
  Color.fromRGBO(255, 182, 185, 1),
  Color.fromRGBO(190, 235, 233, 1),
];

const ICONS = [
  MyCustomIcons.emo_happy, //0
  MyCustomIcons.emo_unhappy, //1
  MyCustomIcons.emo_laugh, //2
  MyCustomIcons.emo_displeased, //3
  MyCustomIcons.emo_angry, //4
  MyCustomIcons.emo_wink, //5
  MyCustomIcons.emo_coffee, //6
  MyCustomIcons.emo_beer, //7
  MyCustomIcons.emo_sleep, //8
  MyCustomIcons.thumbs_up, //9
  MyCustomIcons.thumbs_down, //10
  MyCustomIcons.check_circle, //11
  MyCustomIcons.times_circle, //12
  MyCustomIcons.comments, //13
  MyCustomIcons.comment_dots, //14
  MyCustomIcons.comment_slash, //15
  MyCustomIcons.heart, //16
  MyCustomIcons.heart_broken, //17
  MyCustomIcons.heartbeat, //18
  UniconsLine.sun, //19
  UniconsLine.sunset, //20
  MyCustomIcons.cloud_sun, //21
  MyCustomIcons.drizzle, //22
  MyCustomIcons.cloud_flash, //23
  UniconsLine.phone_alt, //24
  UniconsLine.phone_slash, //25
  UniconsLine.microphone, //26
  UniconsLine.desktop, //27
  UniconsLine.laptop, //28
  UniconsLine.mobile_android, //29
  UniconsLine.print, //30
  UniconsLine.meeting_board, //31
  UniconsLine.book_open, //32
  UniconsLine.book_alt, //33
  UniconsLine.notes, //34
  UniconsLine.clipboard_notes, //35
  UniconsLine.chart, //36
  UniconsLine.edit, //37
  UniconsLine.envelope, //38
  UniconsLine.paperclip, //39
  UniconsLine.folder_open, //40
  UniconsLine.flask, //41
  UniconsLine.telescope, //42
  UniconsLine.microscope, //43
  UniconsLine.medkit, //44
  UniconsLine.stethoscope, //45
  UniconsLine.syringe, //46
  UniconsLine.drill, //47
  UniconsLine.paint_tool, //48
  UniconsLine.ruler, //49
  UniconsLine.screw, //50
  UniconsLine.shovel, //51
  UniconsLine.traffic_barrier, //52
  MyCustomIcons.battery, //53
  MyCustomIcons.cog, //54
  MyCustomIcons.bed, //55
  MyCustomIcons.car_side, //56
  MyCustomIcons.dribbble, //57
  MyCustomIcons.gamepad, //58
  MyCustomIcons.dumbbell, //59
  MyCustomIcons.flame, //60
  MyCustomIcons.glasses, //61
  MyCustomIcons.hourglass, //62
  MyCustomIcons.leaf_1, //63
  MyCustomIcons.lightbulb, //64
  MyCustomIcons.mug_hot, //65
  MyCustomIcons.music, //66
  MyCustomIcons.palette, //67
  MyCustomIcons.paw, //68
  MyCustomIcons.pizza_slice, //69
  MyCustomIcons.skull, //70
  MyCustomIcons.star, //71
  MyCustomIcons.tint, //72
  MyCustomIcons.umbrella_beach, //73
  MyCustomIcons.medal, // 74
];

class ThemedContainer extends StatelessWidget {
  //const ThemedContainer({Key? key}) : super(key: key);

  final Widget child;
  final AlignmentGeometry? alignment;

  const ThemedContainer({required this.child, this.alignment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: COLOR[2],
      ),
      child: child,
    );
  }
}

class ThemedContainer2 extends StatelessWidget {
  final Widget child;

  const ThemedContainer2({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: COLOR[3],
        border: Border.all(color: Theme.of(context).primaryColor, width: 5),
      ),
      child: child,
    );
  }
}

class ThemedFormContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final AlignmentGeometry? alignment;

  const ThemedFormContainer(
      {required this.child, this.height, this.width, this.alignment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        color: COLOR[0],
      ),
      height: height,
      width: width,
      alignment: alignment,
      child: child,
    );
  }
}

class ValidationDialog extends StatelessWidget {
  final double? height;
  final double? width;
  final String title;
  final String? description;
  final bool isForConfirmation;
  final Icon? icon;
  final Widget? descriptionWidget;

  ValidationDialog({
    this.height,
    this.width,
    required this.title,
    this.description,
    required this.isForConfirmation,
    this.icon,
    this.descriptionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedFormContainer(
      // height: height,
      // width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null)
            Row(children: [
              icon!,
              const SizedBox(
                width: 20,
              ),
              PageHeading(pageTitle: title),
            ]),
          if (icon == null) PageHeading(pageTitle: title),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 2,
          ),
          if (description != null) Text(description!),
          if (descriptionWidget != null) descriptionWidget!,
          const SizedBox(
            height: 20,
          ),
          if (isForConfirmation)
            Row(
              children: <Widget>[
                Expanded(
                  child: ThemedButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ThemedButton(
                      child: const Text('Yes'),
                      onPressed: () => Navigator.of(context).pop(true)),
                ),
              ],
            ),
          if (!isForConfirmation)
            ThemedButton(
                child: const Text('Okay'),
                onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

class ThemedButton extends StatelessWidget {
  //const ThemedButton({Key? key}) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final Color? color;

  bool? isDisabled;

  ThemedButton({
    required this.child,
    required this.onPressed,
    this.isDisabled,
    this.color,
  }) {
    if (isDisabled == null) {
      isDisabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled! ? null : onPressed,
      style: ElevatedButton.styleFrom(
        //primary: isDisabled! ? COLOR[3] : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        primary: color,
      ),
      child: child,
    );
  }
}

class MySnackBar extends SnackBar {
  MySnackBar({required this.context, required this.child, Key? key})
      : super(
          content: child,
          duration: const Duration(milliseconds: 1500),
          backgroundColor: Theme.of(context).primaryColor,
          key: key,
        );

  final BuildContext context;
  final Widget child;
}
