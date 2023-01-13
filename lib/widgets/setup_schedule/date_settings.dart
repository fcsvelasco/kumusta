import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styling/my_consumer_widget.dart';
import '../../models/tracker.dart';
import '../../styling/app_theme_data.dart';

class DateSettings extends MyConsumerWidget {
  const DateSettings({Key? key}) : super(key: key);

  void showDatesInfo(BuildContext context) {
    showValidationDialog(
      context: context,
      title: 'Date Range',
      description:
          '''Here, you provide the start and end dates for your tracker. Usually, tracking takes two (2) to three (3) weeks, but it also depends on your chosen days of the week and length of time for each day.

If you are not sure of what to put here, you may set a duration of 3 weeks.''',
      isForConfirmation: false,
      icon: Icon(
        Icons.info_rounded,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  void startSelectDateRange({
    required WidgetRef ref,
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTimeRange initialDateRange,
  }) {
    showDateRangePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
        initialDateRange: initialDateRange,
        builder: (BuildContext context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.black,
                ),
                scaffoldBackgroundColor: COLOR[0],
              ),
              child: child!);
        }).then((value) {
      if (value == null) {
        return;
      }
      final trackerNotifier = ref.read(trackerProvider.notifier);
      trackerNotifier.setStartDate(value.start);
      trackerNotifier.setEndDate(value.end);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(trackerProvider);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      //color: COLOR[0],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Dates',
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
                    onTap: () => showDatesInfo(context),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Theme.of(context).accentColor,
                    ),
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
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Flexible(
                    flex: 1, fit: FlexFit.tight, child: Text('From: ')),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    DateFormat.yMMMd('en_US').format(tracker.startDate),
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 16,
                      //color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const Flexible(
                    flex: 1, fit: FlexFit.tight, child: Text('To: ')),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    DateFormat.yMMMd('en_US').format(tracker.endDate),
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 16,
                      //color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              //color: Theme.of(context).accentColor,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).accentColor),
              ),
              child: Text(
                'Edit Date Range',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: () {
                final today = DateTime.now();
                startSelectDateRange(
                  ref: ref,
                  context: context,
                  firstDate: DateTime(
                    today.year,
                    today.month,
                    today.day + 1,
                  ),
                  lastDate: DateTime(
                    tracker.startDate.year,
                    tracker.startDate.month + 3,
                    tracker.startDate.day,
                  ),
                  initialDateRange: DateTimeRange(
                      start: tracker.startDate, end: tracker.endDate),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
