import 'dart:math';
import 'package:flutter/material.dart';

import '../styling/my_custom_icons_icons.dart';

enum ResponseScenario {
  recent,
  notRecent,
}

class Response {
  final String title;
  final String content;
  final IconData iconData;

  Response._privateConstructor({
    required this.title,
    required this.content,
    required this.iconData,
  });

  static final _recentResponses = [
    Response._privateConstructor(
      title: 'Keep fighting!',
      content:
          'Or take some rest. It can get hard sometimes, but it does get better!',
      iconData: MyCustomIcons.heartbeat,
    ),
    Response._privateConstructor(
      title: 'Stay strong!',
      content:
          'But it’s okay if you can’t right now. Just know that things do get better.',
      iconData: MyCustomIcons.heartbeat,
    ),
    Response._privateConstructor(
      title: 'Take a deep breath',
      content: 'It can get hard and messy sometimes, but this too shall pass.',
      iconData: MyCustomIcons.leaf_1,
    ),
    Response._privateConstructor(
      title: 'Take the time you need',
      content: 'Things will get better. I believe in you!',
      iconData: MyCustomIcons.hourglass,
    ),
    Response._privateConstructor(
      title: 'Hang in there!',
      content:
          'It gets better, really! Keep fighting or take the rest you need.',
      iconData: MyCustomIcons.cloud_sun,
    ),
    Response._privateConstructor(
      title: 'It gets better!',
      content:
          'I don\'t know what you\'re going through, but I hope you feel better soon!',
      iconData: MyCustomIcons.cloud_sun,
    ),
  ];

  static final _notRecentResponses = [
    Response._privateConstructor(
      title: 'I hope you feel better now.',
      content:
          'If not, I hope you feel better soon. Everything passes, especially the negative feelings.',
      iconData: MyCustomIcons.heartbeat,
    ),
  ];

  static Response get(ResponseScenario responseScenario) {
    if (responseScenario == ResponseScenario.recent) {
      return _recentResponses[Random().nextInt(_recentResponses.length)];
    } else {
      return _notRecentResponses[0];
    }
  }
}
