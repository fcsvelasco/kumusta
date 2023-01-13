import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksampler/styling/app_theme_data.dart';

import '../models/observation.dart';
import './observation_unit.dart';

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
        ? Container(
            alignment: Alignment.center,
            height: double.infinity,
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(
                Icons.check_box_rounded,
                color: Theme.of(context).accentColor,
                size: 50,
              ),
              title: const Text(
                'No Pending Self-Checks',
                style: TextStyle(fontSize: 18),
              ),
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
