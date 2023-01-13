import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/my_consumer_widget.dart';
import './select_time.dart';

class TimeSettings extends MyConsumerWidget {
  const TimeSettings({Key? key}) : super(key: key);

  void showTimeInfo(BuildContext context) {
    showValidationDialog(
      context: context,
      title: 'Time',
      description:
          '''Here, you select the start time and end time of tracking per day. The random self-checks will be done within the time range that you select

It\'s up to you if you want to input your workhours, or the start and end of your usual day, or any specific time range of the day.''',
      isForConfirmation: false,
      icon: Icon(
        Icons.info_rounded,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Time',
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
                    onTap: () => showTimeInfo(context),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            // Row(
            //   children: [
            //     Checkbox(
            //       value: tracker.isSameTimeForAllDays,
            //       onChanged: (val) {
            //         trackerNotifier.toggleIsSameTimeForAllDays(val!);
            //       },
            //     ),
            //     const Text('Same time for all selected days'),
            //   ],
            // ),
            // if (tracker.trackerMode == TrackerMode.activitySampling)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Switch(
            //         value: tracker.isWithBreakTime,
            //         onChanged: (val) {
            //           trackerNotifier.toggleIsWithBreakTime(val);
            //         },
            //       ),
            //       const Text('With breaktime'),
            //     ],
            //   ),
            SelectTime(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
