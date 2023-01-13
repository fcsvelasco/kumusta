import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/my_consumer_widget.dart';
import '../models/tracker.dart';
import '../models/day.dart';
import './day_button.dart';

class DaySettings extends MyConsumerWidget {
  const DaySettings({Key? key}) : super(key: key);

  void showDaysInfo(BuildContext context, TrackerMode trackerMode) {
    showValidationDialog(
      context: context,
      title: 'Days',
      description: trackerMode == TrackerMode.activitySampling
          ? '''Here, you select the days when the random self-checks will be done.

The days you select depend on what you want to track. If you want to track your activities during work, which is a common use of this tracker, you select your workdays.

If you simply want to track your daily activities, you can select certain days or all the days.'''
          : '''Here, you select the days when the random self-checks will be done.
          
The days you select depend on what you want to track. You may select all the days if you want to track your mood throught the week. You may also select your workdays if you want to track your mood while working. You may also select certain days of the week depending on your purpose of using this tracker.''',
      isForConfirmation: false,
      icon: Icon(
        Icons.info_rounded,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(daysProvider);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Days',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => showDaysInfo(
                        context, ref.read(trackerProvider).trackerMode),
                    child: Icon(Icons.info_outline_rounded,
                        color: Theme.of(context).accentColor),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                ...days.map((d) {
                  if (d.id != DayId.anyday) {
                    return Expanded(
                      child: DayButton(
                          day: d,
                          onPressed:
                              ref.read(daysProvider.notifier).toggleIsSelected),
                    );
                  } else {
                    return Container();
                  }
                }).toList()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
