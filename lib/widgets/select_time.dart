import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import './select_time_unit.dart';
import '../models/day.dart';

class SelectTime extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(trackerProvider);
    final days = ref.watch(daysProvider);

    var selectedDays = days.where((d) => d.isSelected && d.id != DayId.anyday);

    return Column(
      children: tracker.isSameTimeForAllDays
          ? <Widget>[
              SelectTimeUnit(day: days[DayId.anyday.index]),
            ]
          : <Widget>[
              ...selectedDays.map((day) {
                return Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      day.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SelectTimeUnit(
                      day: day,
                    ),
                  ],
                );
              }).toList()
            ],
    );
  }
}
