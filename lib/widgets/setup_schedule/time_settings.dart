import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styling/app_theme_data.dart';
import '../../models/day.dart';
import '../../models/tracker.dart';
import '../../styling/my_consumer_widget.dart';

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

class SelectTimeUnit extends ConsumerWidget {
  final Day day;

  const SelectTimeUnit({
    required this.day,
  });

  void startTimeSelection(
    BuildContext ctx,
    Day day,
    TimeCategory timeCategory,
    WidgetRef ref,
  ) {
    showTimePicker(
      context: ctx,
      initialTime:
          day.getTime(timeCategory) ?? const TimeOfDay(hour: 0, minute: 0),
    ).then((pickedTime) {
      if (pickedTime == null) {
      } else {
        if (day.id == DayId.anyday) {
          ref
              .read(daysProvider.notifier)
              .updateTimeForAll(Wrapped.value(pickedTime), timeCategory);
          ref.read(trackerProvider.notifier).checkAndUpdateIfNightShift(ref);
        } else {
          ref
              .read(daysProvider.notifier)
              .updateTime(day.id, Wrapped.value(pickedTime), timeCategory);
          ref.read(daysProvider.notifier).resetTimeForAnyDay(timeCategory);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(trackerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //const Text('Observation Time'),
        Row(
          children: <Widget>[
            const Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                'Start:',
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: OutlinedButton(
                //color: Theme.of(context).accentColor,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  startTimeSelection(
                      context, day, TimeCategory.observationStartTime, ref);
                },
                child: day.observationStartTime == null
                    ? Text(
                        'Pick Time',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      )
                    : Text(
                        day.observationStartTime!.format(context),
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
              ),
            ),
            const Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                'End:',
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: OutlinedButton(
                //color: Theme.of(context).accentColor,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  startTimeSelection(
                      context, day, TimeCategory.observationEndTime, ref);
                },
                child: day.observationEndTime == null
                    ? Text(
                        'Pick Time',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      )
                    : Text(
                        day.observationEndTime!.format(context),
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
              ),
            ),
          ],
        ),
        if (tracker.isWithBreakTime) ...[
          const Text('Break Time'),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  'Start:',
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: ThemedButton(
                  onPressed: () {
                    startTimeSelection(
                        context, day, TimeCategory.breakStartTime, ref);
                  },
                  child: day.breakStartTime == null
                      ? const Text('Pick Time')
                      : Text(day.breakStartTime!.format(context)),
                ),
              ),
              const Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  'End:',
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: ThemedButton(
                  onPressed: () {
                    startTimeSelection(
                        context, day, TimeCategory.breakEndTime, ref);
                  },
                  child: day.breakEndTime == null
                      ? const Text('Pick Time')
                      : Text(day.breakEndTime!.format(context)),
                ),
              ),
            ],
          ),
        ]
      ],
    );
  }
}
