import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/day.dart';
import '../../models/tracker.dart';
import '../../styling/page_heading.dart';

class ScheduleSummary extends ConsumerWidget {
  const ScheduleSummary({
    required this.isForVerifySettingsPage,
    Key? key,
  }) : super(key: key);

  final bool isForVerifySettingsPage;

  Widget scheduleSummaryBuilder(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(trackerProvider);
    final selectedDays =
        ref.watch(daysProvider).where((element) => element.isSelected).toList();
    final selectedDaysAbbrev = selectedDays
        .map(
          (e) => e.shortName,
        )
        .toString();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: isForVerifySettingsPage
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: PageHeading(
              pageTitle: isForVerifySettingsPage ? 'Schedule' : 'Summary',
              pageTitleColor: isForVerifySettingsPage
                  ? Theme.of(context).accentColor
                  : Colors.white,
            ),
          ),
          Divider(
            thickness: 2,
            color: isForVerifySettingsPage ? null : Colors.white54,
          ),
          if (isForVerifySettingsPage)
            ListTile(
              leading: Icon(
                Icons.check_rounded,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Self-checks start on ${DateFormat.yMMMd('en_US').format(tracker.startDate)} and end on ${DateFormat.yMMMd('en_US').format(tracker.endDate)}',
              ),
            ),
          if (isForVerifySettingsPage)
            ListTile(
              leading: Icon(
                Icons.check_rounded,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                  'Random self-checks happen every ${selectedDaysAbbrev.substring(1, selectedDaysAbbrev.length - 1)} from ${selectedDays[0].observationStartTime!.format(context)} to ${selectedDays[0].observationEndTime!.format(context)}'),
            ),
          if (selectedDays.isNotEmpty)
            ListTile(
              leading: Icon(
                Icons.check_rounded,
                color: isForVerifySettingsPage
                    ? Theme.of(context).accentColor
                    : Colors.white,
              ),
              title: Text(
                'Number of days with self-checks: ${tracker.observationDaysCount(selectedDays)}',
                style: isForVerifySettingsPage
                    ? null
                    : const TextStyle(color: Colors.white),
              ),
            ),
          if (selectedDays.isNotEmpty)
            ListTile(
              leading: Icon(
                Icons.check_rounded,
                color: isForVerifySettingsPage
                    ? Theme.of(context).accentColor
                    : Colors.white,
              ),
              title: Text(
                'Self-checks per day: ${tracker.observationsPerDay(selectedDays)}',
                style: isForVerifySettingsPage
                    ? null
                    : const TextStyle(color: Colors.white),
              ),
            ),
          if (selectedDays.isNotEmpty &&
              selectedDays[0].observationStartTime != null &&
              selectedDays[0].observationEndTime != null)
            ListTile(
              leading: Icon(
                Icons.check_rounded,
                color: isForVerifySettingsPage
                    ? Theme.of(context).accentColor
                    : Colors.white,
              ),
              title: Text(
                'Self-checks to be recorded every ${tracker.minutesPerObservation(selectedDays).toStringAsFixed(0)} mins on average',
                style: isForVerifySettingsPage
                    ? null
                    : const TextStyle(color: Colors.white),
              ),
            ),
        ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isForVerifySettingsPage
        ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: scheduleSummaryBuilder(context, ref),
            ),
          )
        : Container(
            child: scheduleSummaryBuilder(context, ref),
          );
  }
}
