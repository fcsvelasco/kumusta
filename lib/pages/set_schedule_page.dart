import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styling/cutom_appbar.dart';
import '../styling/my_consumer_widget.dart';
import '../models/tracker.dart';
import '../widgets/setup_schedule/date_settings.dart';
import '../widgets/setup_schedule/schedule_summary.dart';
import './set_activities_page.dart';
import '../styling/page_heading.dart';
import '../widgets/setup_schedule/day_settings.dart';
import '../widgets/setup_schedule/time_settings.dart';
import '../models/day.dart';
import '../styling/app_theme_data.dart';
import '../widgets/setup_schedule/frequency_settings.dart';

class SetSchedulePage extends MyConsumerWidget {
  Future<bool> goodScheduleInput(BuildContext context, WidgetRef ref) async {
    List<Day> days = ref.watch(daysProvider);
    List<Day> selectedDays =
        days.where((element) => element.isSelected).toList();
    Tracker tracker = ref.watch(trackerProvider);

    if (selectedDays.isEmpty) {
      showValidationDialog(
        context: context,
        title: 'Invalid Schedule',
        description:
            'Please select days when the random self-checks will be conducted.',
        isForConfirmation: false,
      );
      return false;
    }
    if (days[DayId.anyday.index].observationStartTime == null ||
        days[DayId.anyday.index].observationEndTime == null) {
      showValidationDialog(
        context: context,
        title: 'Invalid Schedule',
        description:
            'Please input start time and end time of when the random self-checks will be conducted.',
        isForConfirmation: false,
      );
      return false;
    }
    if (days[DayId.anyday.index].isObservationStartEqualsEnd) {
      showValidationDialog(
        context: context,
        title: 'Invalid Schedule',
        description: 'Start time and end time cannot be the same.',
        isForConfirmation: false,
      );
      return false;
    }

    if (tracker.isWithBreakTime &&
        (days[DayId.anyday.index].breakStartTime == null ||
            days[DayId.anyday.index].breakEndTime == null)) {
      showValidationDialog(
        context: context,
        title: 'Invalid Schedule',
        description:
            'Please input start and end of breaktime or untoggle the "With breaktime" option',
        isForConfirmation: false,
      );
      return false;
    }
    if (tracker.isWithBreakTime &&
        (((!days[DayId.anyday.index].isObservationStartAfterEnd) &&
                (days[DayId.anyday.index].isBreakStartAfterEnd)) ||
            days[DayId.anyday.index].isBreakStartEqualsEnd)) {
      showValidationDialog(
        context: context,
        title: 'Invalid Schedule',
        description: 'Invalid time inputs. Please check again.',
        isForConfirmation: false,
      );
      return false;
    }

    if (tracker.isWithBreakTime &&
        ((days[DayId.anyday.index].isObservationStartAfterBreakStart &&
                days[DayId.anyday.index].isObservationEndAfterBreakEnd) ||
            (!days[DayId.anyday.index].isObservationStartAfterBreakStart &&
                !days[DayId.anyday.index].isObservationEndAfterBreakEnd))) {
      showValidationDialog(
        context: context,
        title: 'Invalid Schedule',
        description: 'Invalid time inputs. Please check again.',
        isForConfirmation: false,
      );
      return false;
    }

    if (tracker.observationDaysCount(selectedDays) < 10) {
      showValidationDialog(
        context: context,
        title: 'Invalid Schedule',
        description:
            '''Number of days with self-checks should not be less than 10.

It is recommended that you extend the date range or include more days for self-checks, whichever is more applicable.''',
        isForConfirmation: false,
      );
      return false;
    }
    // if (tracker.minutesPerObservation <
    //     Tracker.minAverageObservationInterval) {
    //   showValidationDialog(
    //     context: context,
    //     title: 'Too Frequent Self-Checks',
    //     descriptionWidget: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Text(
    //           'Based on the schedule, self-checks will happen too frequently which may cause inconvenience to you.',
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         const Text(
    //             'Consider increasing the tracking time by making any of the following adjustments:'),
    //         ListTile(
    //           leading: Icon(
    //             Icons.crop_square_rounded,
    //             color: Theme.of(context).accentColor,
    //           ),
    //           title: const Text('Extending the date range of the tracker'),
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             Icons.crop_square_rounded,
    //             color: Theme.of(context).accentColor,
    //           ),
    //           title:
    //               const Text('Selecting more days of the week (if possible)'),
    //         ),
    //         ListTile(
    //           leading: Icon(
    //             Icons.crop_square_rounded,
    //             color: Theme.of(context).accentColor,
    //           ),
    //           title: const Text('Extending the time duration per day'),
    //         ),
    //       ],
    //     ),
    //     isForConfirmation: false,
    //   );
    //   return false;
    // }

    if (tracker.isNightShift) {
      return await showValidationDialog(
        context: context,
        title: 'Confirm',
        description: tracker.trackerMode == TrackerMode.activitySampling
            ? 'It seems that you have a night shift schedule. Are you sure about this?'
            : 'It seems that you are a night owl! Are you sure about your start time and end time?',
        isForConfirmation: true,
      );
    }

    return true;
  }

  void goToNextPage(BuildContext context, WidgetRef ref) {
    goodScheduleInput(context, ref).then((value) {
      if (value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SetActivitiesPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final mq = MediaQuery.of(context);
    final trackerMode = ref.read(trackerProvider).trackerMode;
    // final appBar = AppBar(
    //   title: const Text('Set Up Your Tracker'),
    // );
    final appBar = CustomAppBar();

    return Scaffold(
      appBar: appBar,
      body: Container(
        color: COLOR[0],
        //padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 30,
                right: 30,
                bottom: 30,
              ),
              //margin: const EdgeInsets.only(right: 30),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Theme.of(context).primaryColor,
              ),
              alignment: Alignment.topLeft,
              child: PageHeading(
                pageTitle: 'Step 1: Set your schedule!',
                pageDescription: trackerMode == TrackerMode.activitySampling
                    ? 'In this section, you set the schedule of monitoring your productivity. At random times within your selected schedule, you will receive reminders to check up on yourself.'
                    : 'In this section, you set the schedule of monitoring your mood. At random times within your selected schedule, you will receive reminders to check up on yourself.',
                pageTitleColor: Colors.white,
                pageDescriptionColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: DateSettings(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: DaySettings(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: TimeSettings(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: FrequencySettings(),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(left: 30),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: Theme.of(context).primaryColor,
              ),
              child: const ScheduleSummary(
                isForVerifySettingsPage: false,
              ),
            ),
            Column(children: [
              ThemedButton(
                onPressed: () {
                  goToNextPage(context, ref);
                },
                //color: Theme.of(context).accentColor,
                child: const Text(
                  'Next',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ])
          ],
        ),
      ),
    );
  }
}
