import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './dummy_data.dart';
import './activity.dart';
import './observation.dart';
import './day.dart';
import '../services/database_helper.dart';

enum TrackerMode { activitySampling, moodSampling }

enum TrackerStatus { current, finished, unfinished }

enum TrackerFrequency { relaxed, moderate, frequent }

class Tracker {
  static const maxTrackers = 20;
  static const maxActivities = 20;
  static const minAverageObservationInterval = 10;
  static const minObservationInterval = 3;

  final int id;
  final bool isSameTimeForAllDays;
  final bool isWithBreakTime;
  final bool isNightShift;
  final bool isActivitiesCategorized;
  final TrackerMode trackerMode;
  final TrackerStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final TrackerFrequency trackerFrequency;

  const Tracker({
    required this.id,
    required this.isSameTimeForAllDays,
    required this.isWithBreakTime,
    required this.isNightShift,
    required this.isActivitiesCategorized,
    required this.trackerMode,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.trackerFrequency,
  });

  Tracker copyWith({
    int? id,
    bool? isSameTimeForAllDays,
    bool? isWithBreakTime,
    bool? isNightShift,
    bool? isActivitiesCategorized,
    TrackerMode? trackerMode,
    List<Activity>? activities,
    List<Observation>? observations,
    List<Day>? selectedDays,
    TrackerStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    TrackerFrequency? trackerFrequency,
  }) {
    return Tracker(
      id: id ?? this.id,
      isSameTimeForAllDays: isSameTimeForAllDays ?? this.isSameTimeForAllDays,
      isWithBreakTime: isWithBreakTime ?? this.isWithBreakTime,
      isNightShift: isNightShift ?? this.isNightShift,
      isActivitiesCategorized:
          isActivitiesCategorized ?? this.isActivitiesCategorized,
      trackerMode: trackerMode ?? this.trackerMode,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      trackerFrequency: trackerFrequency ?? this.trackerFrequency,
    );
  }

  static Future<Tracker> sampleTracker() async {
    //print(sampleTracker);
    return Tracker(
      id: 0,
      isSameTimeForAllDays: true,
      isWithBreakTime: false,
      isNightShift: false,
      isActivitiesCategorized: true,
      trackerMode: TrackerMode.activitySampling,
      status: TrackerStatus.current,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 21)),
      trackerFrequency: TrackerFrequency.moderate,
    );
  }

  Map<ActivityCategory, String> get categories {
    if (trackerMode == TrackerMode.activitySampling) {
      return {
        ActivityCategory.productive: 'Productive',
        ActivityCategory.necessary: 'Necessary',
        ActivityCategory.waste: 'Waste',
        ActivityCategory.uncategorized: 'Uncategorized',
      };
    } else {
      return {
        ActivityCategory.productive: 'Positive',
        ActivityCategory.necessary: 'Neutral',
        ActivityCategory.waste: 'Negative',
        ActivityCategory.uncategorized: 'Uncategorized',
      };
    }
  }

  List<String> get categoriesList {
    return [
      categories[ActivityCategory.productive]!,
      categories[ActivityCategory.necessary]!,
      categories[ActivityCategory.waste]!,
      categories[ActivityCategory.uncategorized]!,
    ];
  }

  factory Tracker.fromMap(Map<String, dynamic> json) {
    //print('Tracker.fromMap()');
    try {
      return Tracker(
        id: json['id'],
        isSameTimeForAllDays: json['isSameTimeForAllDays'] == 1 ? true : false,
        isWithBreakTime: json['isWithBreakTime'] == 1 ? true : false,
        isNightShift: json['isNightShift'] == 1 ? true : false,
        isActivitiesCategorized:
            json['isActivitiesCategorized'] == 1 ? true : false,
        trackerMode: TrackerMode.values[json['trackerMode']],
        status: TrackerStatus.values[json['status']],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        trackerFrequency: TrackerFrequency
            .moderate, //trackerFrequency is not recorded in sqflite and is only needed during generation of observations sched
      );
    } catch (e) {
      //print('In Tracker.fromMap() error: $e');
      return Tracker(
        id: 99,
        isSameTimeForAllDays: true,
        isWithBreakTime: false,
        isNightShift: false,
        isActivitiesCategorized: true,
        trackerMode: TrackerMode.activitySampling,
        status: TrackerStatus.current,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 21)),
        trackerFrequency: TrackerFrequency.moderate,
      );
    }
  }

  Map<String, dynamic> toMap(bool isForInsert) {
    //print('toMap()');
    try {
      return {
        'id': isForInsert ? null : id,
        'isSameTimeForAllDays': isSameTimeForAllDays ? 1 : 0,
        'isWithBreakTime': isWithBreakTime ? 1 : 0,
        'isNightShift': isNightShift ? 1 : 0,
        'isActivitiesCategorized': isActivitiesCategorized ? 1 : 0,
        'trackerMode': trackerMode.index,
        'status': status.index,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
    } catch (e) {
      //print('In tracker.toMap() error: $e');
      return {
        'id': 99,
        'isSameTimeForAllDays': isSameTimeForAllDays ? 1 : 0,
        'isWithBreakTime': isWithBreakTime ? 1 : 0,
        'isNightShift': isNightShift ? 1 : 0,
        'isActivitiesCategorized': isActivitiesCategorized ? 1 : 0,
        'trackerMode': trackerMode.index,
        'status': status.index,
        'startDate': startDate.toIso8601String(),
        'endDate': startDate.toIso8601String(),
      };
    }
  }

  int observationDaysCount(List<Day> selectedDays) {
    var observationDaysCount = 0;
    for (var day = startDate;
        day.isBefore(DateTime(
      endDate.year,
      endDate.month,
      endDate.day + 1,
      endDate.hour,
      endDate.minute,
      endDate.second,
    ));
        day = DateTime(
      day.year,
      day.month,
      day.day + 1,
      day.hour,
      day.minute,
      day.second,
    )) {
      //print('counting observationDaysCount: $observationDaysCount');
      if (selectedDays
          .where((selectedDay) =>
              selectedDay.name == DateFormat('EEEE').format(day))
          .isNotEmpty) {
        observationDaysCount++;
      }
    }
    return observationDaysCount;
  }

  int observationsPerDay(WidgetRef ref) {
    return (ref
                .read(daysProvider)[DayId.anyday.index]
                .observationTimeRangeInMinutes(isNightShift) /
            minutesPerObservation)
        .floor();
  }

  double get minutesPerObservation {
    switch (trackerFrequency) {
      case TrackerFrequency.relaxed:
        return 60;
      case TrackerFrequency.moderate:
        return 30;
      case TrackerFrequency.frequent:
        return 10;
    }
  }

  int randomTimeInterval(TrackerFrequency trackerFrequency) {
    switch (trackerFrequency) {
      case TrackerFrequency.relaxed:
        return Random().nextInt(30) + 45; // any integer from 45 to 75
      case TrackerFrequency.moderate:
        return Random().nextInt(20) + 20; // any integer from 20 to 30
      case TrackerFrequency.frequent:
        return Random().nextInt(10) + 5; // any integer from 5 to 15
    }
  }

  Future<void> generateObservations(
    List<Day> selectedDays,
    WidgetRef ref,
    TrackerFrequency trackerFrequency,
  ) async {
    //print('generateObservation()');

    List<Observation> observationsList = [];
    for (var day = startDate;
        day.isBefore(
      DateTime(
        endDate.year,
        endDate.month,
        endDate.day + 1,
        endDate.hour,
        endDate.minute,
        endDate.second,
      ),
    );
        day = DateTime(
      day.year,
      day.month,
      day.day + 1,
      day.hour,
      day.minute,
      day.second,
    ),) {
      Day dayModel = selectedDays.firstWhere(
          (element) => element.name == DateFormat('EEEE').format(day),
          orElse: () => Day.anyday(id));

      if (dayModel.name != Day.anyday(id).name) {
        int newTimeInMinutes = dayModel.observationStartTimeInMinutes() +
            randomTimeInterval(trackerFrequency);

        while (newTimeInMinutes <=
            dayModel.observationEndTimeInMinutes(isNightShift)) {
          late final TimeOfDay randomTimeOfDay;
          late final DateTime randomDateTime;
          if (newTimeInMinutes >= 24 * 60) {
            randomTimeOfDay = TimeOfDay(
                hour: (newTimeInMinutes / 60).floor() - 24,
                minute: newTimeInMinutes % 60);
            randomDateTime = DateTime(
              day.year,
              day.month,
              day.day + 1,
              randomTimeOfDay.hour,
              randomTimeOfDay.minute,
            );
          } else {
            randomTimeOfDay = TimeOfDay(
                hour: (newTimeInMinutes / 60).floor(),
                minute: newTimeInMinutes % 60);
            randomDateTime = DateTime(
              day.year,
              day.month,
              day.day,
              randomTimeOfDay.hour,
              randomTimeOfDay.minute,
            );
          }

          observationsList.add(Observation(
            trackerId: id,
            id: randomDateTime.toIso8601String(),
            dateTime: randomDateTime,
            activityName: '',
            status: ObservationStatus.waiting,
          ));

          newTimeInMinutes += randomTimeInterval(trackerFrequency);
        }
      }
    }
    //print('observationsList.length: ${observationsList.length}');

    observationsList.sort(((a, b) => a.dateTime.millisecondsSinceEpoch
        .compareTo(b.dateTime.millisecondsSinceEpoch)));

    ref
        .read(observationsProvider.notifier)
        .loadObservationsToNotifier(observationsList);
  }

  Observation nextObservation(WidgetRef ref) {
    return ref.read(observationsProvider).firstWhere(
        (o) =>
            o.status == ObservationStatus.recordNow ||
            o.status == ObservationStatus.waiting, orElse: () {
      return Observation(
          trackerId: 999,
          id: 'dummy',
          dateTime: DateTime.now(),
          activityName: '',
          status: ObservationStatus.waiting);
    });
  }

  List<Observation> nextObservations(WidgetRef ref, int observationsCount) {
    final List<Observation> observations = [];
    final List<Observation> allWaitingObservations = ref
        .read(observationsProvider)
        .where((o) => o.status == ObservationStatus.waiting)
        .toList();

    for (int i = 0;
        i < min<int>(observationsCount, allWaitingObservations.length);
        i++) {
      observations.add(allWaitingObservations[i]);
    }

    return observations;
  }

  List<Observation> firstObservationOfNextDays() {
    final List<Observation> observations = [];

    return observations;
  }

  List<Observation> pendingAndCurrentObservations(WidgetRef ref) {
    return ref
        .read(observationsProvider)
        .where((o) =>
            o.status == ObservationStatus.missed ||
            o.status == ObservationStatus.recordNow)
        .toList();
  }

  bool isWithPendingObservation(WidgetRef ref) {
    final observations = ref.read(observationsProvider);

    if (observations.indexWhere(
            (element) => element.status == ObservationStatus.missed) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }

  int recordedObservationsCount(WidgetRef ref) {
    int count = 0;
    final activities = ref.read(activitiesProvider);
    for (final a in activities) {
      count += a.count;
    }
    return count;
  }

  Future<void> updateObservationsOnLoad(WidgetRef ref) async {
    try {
      //print('tracker.updateObservationsOnLoad()');
      final observations = ref.watch(observationsProvider);
      var val = true;
      var i = observations.indexOf((observations.firstWhere((element) =>
          element.status == ObservationStatus.waiting ||
          element.status == ObservationStatus.recordNow)));
      while (val) {
        if (i == -1) {
          val = false;
        } else {
          final now = DateTime.now();
          final recordingNow = DateTime(
            now.year,
            now.month,
            now.day,
            now.hour,
            now.minute,
          );
          final recordingNowWithAllowance = DateTime(
            now.year,
            now.month,
            now.day,
            now.hour,
            now.minute - Observation.recordNowDuration,
          );
          if (observations[i].dateTime.isBefore(recordingNowWithAllowance)) {
            if (observations[i].status == ObservationStatus.waiting ||
                observations[i].status == ObservationStatus.recordNow) {
              await ref
                  .read(observationsProvider.notifier)
                  .updateObservation(
                    trackerId: id,
                    id: observations[i].id,
                    status: ObservationStatus.missed,
                  )
                  .then((_) => print(
                      'Observation id ${observations[i].id} updated status to: ${ref.read(observationsProvider)[i].status}'));
            }
          } else if (observations[i].dateTime == recordingNow ||
              observations[i].dateTime.isBefore(recordingNow)) {
            await ref
                .read(observationsProvider.notifier)
                .updateObservation(
                  trackerId: id,
                  id: observations[i].id,
                  status: ObservationStatus.recordNow,
                )
                .then((_) => print(
                    'Observation id ${observations[i].id} updated status to: ${ref.read(observationsProvider)[i].status}'));
          } else {
            val = false;
            print('number of observations updated: $i');
          }
        }
        i++;
      }
    } catch (e) {
      //print('tracker.updateObservationsOnLoad() error: $e');
    }
  }

  bool isWithNextObservation(WidgetRef ref) {
    return nextObservation(ref).id != 'dummy';
  }

  bool isTimeToFinishTracking(WidgetRef ref) {
    if (!isWithNextObservation(ref)) {
      if (!isWithPendingObservation(ref)) {
        return true;
      }
    }
    return false;
  }

  static void startNewTrackerSetup(WidgetRef ref, TrackerMode trackerMode) {
    final today = DateTime.now().toLocal();
    if (trackerMode == TrackerMode.activitySampling) {
      ref
          .read(activitiesProvider.notifier)
          .loadActivitiesToNotifier(ACTIVITIES);
    } else {
      ref.read(activitiesProvider.notifier).loadActivitiesToNotifier(MOODS);
    }

    ref.read(observationsProvider.notifier).loadObservationsToNotifier([]);
    ref.read(daysProvider.notifier).resetDaysNotifier();
    ref.read(trackerProvider.notifier).loadTrackerToNotifier(
          Tracker(
            id: 0,
            isSameTimeForAllDays: true,
            isWithBreakTime: false,
            isNightShift: false,
            isActivitiesCategorized: true,
            trackerMode: trackerMode,
            status: TrackerStatus.current,
            startDate: DateTime(
              today.year,
              today.month,
              today.day + 1,
              today.hour,
              today.minute,
              today.second,
            ),
            endDate: DateTime(
              today.year,
              today.month,
              today.day + 21,
              today.hour,
              today.minute,
              today.second,
            ),
            trackerFrequency: TrackerFrequency.moderate,
          ),
        );
  }
}

class TrackerNotifier extends StateNotifier<Tracker> {
  TrackerNotifier()
      : super(Tracker(
          id: 0,
          isSameTimeForAllDays: true,
          isWithBreakTime: false,
          isNightShift: false,
          isActivitiesCategorized: true,
          trackerMode: TrackerMode.activitySampling,
          status: TrackerStatus.current,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 21)),
          trackerFrequency: TrackerFrequency.moderate,
        ));

  void loadTrackerToNotifier(Tracker tracker) {
    state = tracker;
  }

  void toggleIsSameTimeForAllDays(bool val) {
    state = state.copyWith(isSameTimeForAllDays: val);
  }

  void toggleIsWithBreakTime(bool val) {
    state = state.copyWith(isWithBreakTime: val);
  }

  void toggleIsActivitiesCategorized(bool val) {
    state = state.copyWith(isActivitiesCategorized: val);
  }

  void toggleIsNightShift(bool val) {
    state = state.copyWith(isNightShift: val);
  }

  void setStartDate(DateTime dateTime) {
    state = state.copyWith(startDate: dateTime);
  }

  void setEndDate(DateTime dateTime) {
    state = state.copyWith(endDate: dateTime);
  }

  void setFrequency(TrackerFrequency frequency) {
    state = state.copyWith(trackerFrequency: frequency);
  }

  void finishTracking() async {
    state = state.copyWith(status: TrackerStatus.finished);
    await DatabaseHelper.instance.updateTracker(state);
  }

  void checkAndUpdateIfNightShift(WidgetRef ref) {
    final day = ref.read(daysProvider)[7];
    final start = day.observationStartTime;
    final end = day.observationEndTime;
    if (start == null || end == null) {
      toggleIsNightShift(false);
      return;
    }

    toggleIsNightShift(
        start.hour * 60 + start.minute > end.hour * 60 + end.minute);
  }

  // Future<void> unfinishTracker() async {
  //   state = state.copyWith(
  //       status: TrackerStatus.unfinished, endDate: DateTime.now());
  //   await DatabaseHelper.instance.updateTracker(state);
  // }

  Future<void> initTracker() async {
    state = await DatabaseHelper.instance.getCurrentTracker();
  }
}

class TrackersNotifier extends StateNotifier<List<Tracker>> {
  TrackersNotifier() : super([]);

  void loadTrackersToNotifier(List<Tracker> trackers) {
    state = trackers;
  }
}

final trackerProvider =
    StateNotifierProvider<TrackerNotifier, Tracker>((ref) => TrackerNotifier());

final trackersListProvider =
    StateNotifierProvider<TrackersNotifier, List<Tracker>>(
        (ref) => TrackersNotifier());
