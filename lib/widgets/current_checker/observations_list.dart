import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksampler/styling/app_theme_data.dart';

import '../../models/observation.dart';

class ObservationsList extends ConsumerWidget {
  const ObservationsList({
    required this.startRecordObservation,
    Key? key,
  }) : super(key: key);

  final Function startRecordObservation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final observations = ref
        .watch(observationsProvider)
        .where((o) =>
            o.status == ObservationStatus.missed ||
            o.status == ObservationStatus.recordNow)
        .toList();

    return observations.isEmpty
        ? Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.assignment_turned_in_rounded,
                  color: Theme.of(context).accentColor,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'No Pending Self-Checks',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        : Container(
            //color: COLOR[0],
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: observations.length,
                itemBuilder: (context, index) {
                  return ObservationUnit(
                    observation: observations[index],
                    startRecordObservation: startRecordObservation,
                  );
                }),
          );
  }
}

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
