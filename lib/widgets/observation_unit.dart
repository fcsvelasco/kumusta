import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/observation.dart';

class ObservationUnit extends ConsumerWidget {
  const ObservationUnit({
    required this.observation,
    required this.startRecordObservation,
    Key? key,
  }) : super(key: key);

  final Observation observation;
  final Function startRecordObservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final observationStatus = [
      'Waiting',
      'Record Now',
      'Recorded',
      'Missed',
      'Updated',
    ];

    return InkWell(
      onTap: observation.status == ObservationStatus.missed
          ? () => startRecordObservation(observation, true)
          : observation.status == ObservationStatus.recordNow
              ? () => startRecordObservation(observation, false)
              : () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: ListTile(
          leading: Icon(
            Icons.assignment_late_rounded,
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            'Time: ${DateFormat.jm().format(observation.dateTime)}',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              '''Date: ${DateFormat.yMMMd('en_US').format(observation.dateTime)}
Status: ${observationStatus[observation.status.index]}'''),
        ),
      ),
    );
  }
}
