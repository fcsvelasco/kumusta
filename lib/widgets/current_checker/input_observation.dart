import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setup-activities/add_activity_form.dart';
import '../../models/tracker.dart';
import '../../models/activity.dart';
import '../../models/observation.dart';
import '../../styling/app_theme_data.dart';
import '../activities/activity_unit.dart';
import '../activities/activities_list.dart';
import '../../styling/page_heading.dart';

class InputObservation extends ConsumerStatefulWidget {
  const InputObservation({
    required this.isForUpdate,
    required this.observation,
    Key? key,
  }) : super(key: key);

  final bool isForUpdate;
  final Observation observation;

  @override
  ConsumerState<InputObservation> createState() => _InputObservationState();
}

class _InputObservationState extends ConsumerState<InputObservation> {
  Activity? _selectedActivity;
  var cantRemember = false;
  late ActivitiesList activitiesList;

  void _selectActivity(Activity activity, {bool? isNewActivity}) {
    setState(() {
      _selectedActivity = activity;
      cantRemember = false;
    });
    if (isNewActivity != null && isNewActivity) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollToSelectedActivity(activitiesList));
    }
  }

  void _unselectActivity() {
    setState(() {
      _selectedActivity = null;
    });
  }

  void _startAddActivity(
    BuildContext context,
    WidgetRef ref,
    TrackerMode trackerMode,
  ) {
    setState(() {
      _selectedActivity = null;
      cantRemember = false;
    });
    final activitiesCount = ref.read(activitiesProvider).length;

    if (activitiesCount < Tracker.maxActivities) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: AddActivityForm(
              hasStartedTracking: true,
            ),
          );
        },
      ).then((value) {
        if (value == null) {
          return;
        } else {
          _selectActivity(value, isNewActivity: true);
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: ValidationDialog(
              title: trackerMode == TrackerMode.activitySampling
                  ? 'Max Activity Count'
                  : 'Max Mood Count',
              description: trackerMode == TrackerMode.activitySampling
                  ? 'The maximum number of activities has been reached. Consider deleting other items first if you wish to add other activities.'
                  : 'The maximum mood count has been reached. Consider deleting other items first if you wish to add other moods.',
              isForConfirmation: false,
            ),
          );
        },
      );
    }
  }

  void scrollToSelectedActivity(ActivitiesList activitiesList) {
    try {
      Scrollable.ensureVisible(activitiesList.dataKey.currentContext!,
          duration: const Duration(milliseconds: 300));
    } catch (e) {
      //print('Scrollable.ensureVisible error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    activitiesList = ActivitiesList(
      //key: dataKey,
      activityUnitMode: ActivityUnitMode.recording,
      selectedActivity: _selectedActivity,
      selectActivity: _selectActivity,
      unselectActivity: _unselectActivity,
    );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        color: COLOR[0],
      ),
      //height: (mq.size.height) * 0.6,
      width: (mq.size.width) * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              final trackerMode = ref.read(trackerProvider).trackerMode;
              return PageHeading(
                pageTitle: widget.isForUpdate
                    ? 'Self-Check Update'
                    : 'Time for Self-Check!',
                pageDescription: trackerMode == TrackerMode.activitySampling
                    ? widget.isForUpdate
                        ? 'Do you remember what you were doing then?'
                        : 'What are you doing now?'
                    : widget.isForUpdate
                        ? 'Do you remember what you were feeling then?'
                        : 'Which best describes how you feel now?',
              );
            },
          ),
          if (widget.isForUpdate)
            const SizedBox(
              height: 10,
            ),
          if (widget.isForUpdate)
            Text(
                'Time: ${DateFormat.jm().format(widget.observation.dateTime)}'),
          if (widget.isForUpdate)
            Text(
                'Date: ${DateFormat.yMMMMd('en_US').format(widget.observation.dateTime)}'),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white70,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: mq.size.height * 0.25,
                  child: activitiesList,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     scrollToSelectedActivity(activitiesList);
                //   },
                //   child: const Text('Scroll'),
                // ),
                if (ref.read(activitiesProvider).length < Tracker.maxActivities)
                  const SizedBox(
                    height: 10,
                  ),
                if (ref.read(activitiesProvider).length < Tracker.maxActivities)
                  Row(
                    children: [
                      Expanded(
                        //fit: FlexFit.tight,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _startAddActivity(
                                context,
                                ref,
                                ref.read(trackerProvider).trackerMode,
                              );
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                            // backgroundColor:
                            //     false ? Theme.of(context).primaryColor : null,
                          ),
                          child: Text(
                            ref.read(trackerProvider).trackerMode ==
                                    TrackerMode.activitySampling
                                ? 'Add New Activity'
                                : 'Add New Mood',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (widget.isForUpdate)
                  const SizedBox(
                    height: 10,
                  ),
                if (widget.isForUpdate)
                  Row(
                    children: [
                      Expanded(
                        //fit: FlexFit.tight,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _unselectActivity();
                              cantRemember = !cantRemember;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                            backgroundColor: cantRemember
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                          child: Text(
                            'I can\'t remember.',
                            style: TextStyle(
                                fontSize: 16,
                                color: cantRemember
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ThemedButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ThemedButton(
                onPressed: () {
                  int trackerId = ref.read(trackerProvider).id;
                  if (cantRemember) {
                    ref.read(observationsProvider.notifier).updateObservation(
                          trackerId: trackerId,
                          id: widget.observation.id,
                          status: ObservationStatus.updated,
                          dateTimeUpdated: DateTime.now(),
                          activityName: 'Can\'t Remember',
                        );
                    Navigator.of(context).pop('Can\'t Remember');
                  } else {
                    ref
                        .read(activitiesProvider.notifier)
                        .incrementActivityCount(
                            trackerId, _selectedActivity!.name);
                    if (widget.isForUpdate) {
                      ref.read(observationsProvider.notifier).updateObservation(
                            trackerId: trackerId,
                            id: widget.observation.id,
                            status: ObservationStatus.updated,
                            dateTimeUpdated: DateTime.now(),
                            activityName: _selectedActivity!.name,
                          );
                    } else {
                      ref.read(observationsProvider.notifier).updateObservation(
                            trackerId: trackerId,
                            id: widget.observation.id,
                            status: ObservationStatus.recorded,
                            activityName: _selectedActivity!.name,
                          );
                    }
                    Navigator.of(context).pop(_selectedActivity!.category);
                  }
                },
                isDisabled: _selectedActivity == null && !cantRemember,
                child: const Text('Submit!'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
