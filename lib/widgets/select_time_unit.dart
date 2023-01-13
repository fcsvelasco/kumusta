import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import '../models/day.dart';
import '../styling/app_theme_data.dart';

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
