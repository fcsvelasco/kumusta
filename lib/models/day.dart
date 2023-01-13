import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DayId {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  anyday,
}

enum TimeCategory {
  observationStartTime,
  observationEndTime,
  breakStartTime,
  breakEndTime,
}

class Day {
  final int trackerId;
  final DayId id;
  final bool isSelected;

  final TimeOfDay? observationStartTime;
  final TimeOfDay? observationEndTime;
  final TimeOfDay? breakStartTime;
  final TimeOfDay? breakEndTime;

  const Day({
    required this.trackerId,
    required this.id,
    required this.isSelected,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.sunday(
    this.trackerId, {
    this.id = DayId.sunday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.monday(
    this.trackerId, {
    this.id = DayId.monday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.tuesday(
    this.trackerId, {
    this.id = DayId.tuesday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.wednesday(
    this.trackerId, {
    this.id = DayId.wednesday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.thursday(
    this.trackerId, {
    this.id = DayId.thursday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.friday(
    this.trackerId, {
    this.id = DayId.friday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.saturday(
    this.trackerId, {
    this.id = DayId.saturday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  const Day.anyday(
    this.trackerId, {
    this.id = DayId.anyday,
    this.isSelected = false,
    this.observationStartTime,
    this.observationEndTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  Day copyWith({
    int? trackerId,
    DayId? id,
    String? name,
    String? shortName,
    bool? isSelected,
    Wrapped<TimeOfDay?>? observationStartTime,
    Wrapped<TimeOfDay?>? observationEndTime,
    Wrapped<TimeOfDay?>? breakStartTime,
    Wrapped<TimeOfDay?>? breakEndTime,
  }) {
    return Day(
      trackerId: trackerId ?? this.trackerId,
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
      observationStartTime: observationStartTime != null
          ? observationStartTime.value
          : this.observationStartTime,
      observationEndTime: observationEndTime != null
          ? observationEndTime.value
          : this.observationEndTime,
      breakStartTime:
          breakStartTime != null ? breakStartTime.value : this.breakStartTime,
      breakEndTime:
          breakEndTime != null ? breakEndTime.value : this.breakEndTime,
    );
  }

  TimeOfDay? getTime(TimeCategory timeCategory) {
    switch (timeCategory) {
      case TimeCategory.observationStartTime:
        return observationStartTime;
      case TimeCategory.observationEndTime:
        return observationEndTime;
      case TimeCategory.breakStartTime:
        return breakStartTime;
      case TimeCategory.breakEndTime:
        return breakEndTime;
      default:
        return null;
    }
  }

  String get name {
    switch (id) {
      case DayId.sunday:
        return 'Sunday';
      case DayId.monday:
        return 'Monday';
      case DayId.tuesday:
        return 'Tuesday';
      case DayId.wednesday:
        return 'Wednesday';
      case DayId.thursday:
        return 'Thursday';
      case DayId.friday:
        return 'Friday';
      case DayId.saturday:
        return 'Saturday';
      case DayId.anyday:
        return 'Any day';
    }
  }

  String get shortName {
    switch (id) {
      case DayId.sunday:
        return 'Su';
      case DayId.monday:
        return 'M';
      case DayId.tuesday:
        return 'Tu';
      case DayId.wednesday:
        return 'W';
      case DayId.thursday:
        return 'Th';
      case DayId.friday:
        return 'F';
      case DayId.saturday:
        return 'Sa';
      case DayId.anyday:
        return 'A';
    }
  }

  factory Day.fromMap(Map<String, dynamic> json) {
    return Day(
      trackerId: json['trackerId'],
      id: DayId.values[json['dayId']],
      isSelected: json['isSelected'] == 1 ? true : false,
      observationStartTime: json['observationStartTimeHr'] == null
          ? null
          : TimeOfDay(
              hour: json['observationStartTimeHr'],
              minute: json['observationStartTimeMin']),
      observationEndTime: json['observationEndTimeHr'] == null
          ? null
          : TimeOfDay(
              hour: json['observationEndTimeHr'],
              minute: json['observationEndTimeMin']),
      breakStartTime: json['breakStartTimeHr'] == null
          ? null
          : TimeOfDay(
              hour: json['breakStartTimeHr'],
              minute: json['breakStartTimeMin']),
      breakEndTime: json['breakEndTimeHr'] == null
          ? null
          : TimeOfDay(
              hour: json['breakEndTimeHr'], minute: json['breakEndTimeMin']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackerId': trackerId,
      'dayId': id.index,
      'isSelected': isSelected ? 1 : 0,
      'observationStartTimeHr':
          observationStartTime == null ? null : observationStartTime!.hour,
      'observationStartTimeMin':
          observationStartTime == null ? null : observationStartTime!.minute,
      'observationEndTimeHr':
          observationEndTime == null ? null : observationEndTime!.hour,
      'observationEndTimeMin':
          observationEndTime == null ? null : observationEndTime!.minute,
      'breakStartTimeHr': breakStartTime == null ? null : breakStartTime!.hour,
      'breakStartTimeMin':
          breakStartTime == null ? null : breakStartTime!.minute,
      'breakEndTimeHr': breakEndTime == null ? null : breakEndTime!.hour,
      'breakEndTimeMin': breakEndTime == null ? null : breakEndTime!.minute,
    };
  }

  int observationTimeRangeInMinutes(bool isNightShift) {
    if (isNightShift) {
      return ((observationEndTime!.hour + 24) * 60 +
              observationEndTime!.minute) -
          (observationStartTime!.hour * 60 + observationStartTime!.minute);
    } else {
      return (observationEndTime!.hour * 60 + observationEndTime!.minute) -
          (observationStartTime!.hour * 60 + observationStartTime!.minute);
    }
  }

  bool get isObservationStartEqualsEnd {
    return observationStartTime!.hour * 60 + observationStartTime!.minute ==
        observationEndTime!.hour * 60 + observationEndTime!.minute;
  }

  bool get isObservationStartAfterEnd {
    return observationStartTime!.hour * 60 + observationStartTime!.minute >
        observationEndTime!.hour * 60 + observationEndTime!.minute;
  }

  bool get isBreakStartEqualsEnd {
    return breakStartTime!.hour * 60 + breakStartTime!.minute ==
        breakEndTime!.hour * 60 + breakEndTime!.minute;
  }

  bool get isBreakStartAfterEnd {
    return breakStartTime!.hour * 60 + breakStartTime!.minute >
        breakEndTime!.hour * 60 + breakEndTime!.minute;
  }

  bool get isObservationStartAfterBreakStart {
    return breakStartTime!.hour * 60 + breakStartTime!.minute <
        observationStartTime!.hour * 60 + observationStartTime!.minute;
  }

  bool get isObservationEndAfterBreakEnd {
    return breakEndTime!.hour * 60 + breakEndTime!.minute <
        observationEndTime!.hour * 60 + observationEndTime!.minute;
  }

  // TimeOfDay randomTimeOfDay(bool isWithBreakTime, bool isNightShift) {
  //   var randomTimeInMinutes = observationStartTime!.hour * 60 +
  //       observationStartTime!.minute +
  //       Random().nextInt(observationTimeRangeInMinutes(isNightShift));

  //   if (isWithBreakTime) {
  //     //check if randomTimeInMinutes is within break time range

  //     if (isNightShift && isBreakStartAfterEnd) {
  //       while (randomTimeInMinutes >=
  //               breakStartTime!.hour * 60 + breakStartTime!.minute &&
  //           randomTimeInMinutes <=
  //               (breakEndTime!.hour + 24) * 60 + breakEndTime!.minute) {
  //         randomTimeInMinutes = observationStartTime!.hour * 60 +
  //             observationStartTime!.minute +
  //             Random().nextInt(observationTimeRangeInMinutes(isNightShift));
  //       }
  //     } else if (isNightShift && isObservationStartAfterBreakStart) {
  //       while (randomTimeInMinutes >=
  //               (breakStartTime!.hour + 24) * 60 + breakStartTime!.minute &&
  //           randomTimeInMinutes <=
  //               (breakEndTime!.hour + 24) * 60 + breakEndTime!.minute) {
  //         randomTimeInMinutes = observationStartTime!.hour * 60 +
  //             observationStartTime!.minute +
  //             Random().nextInt(observationTimeRangeInMinutes(isNightShift));
  //       }
  //     } else {
  //       while (randomTimeInMinutes >=
  //               breakStartTime!.hour * 60 + breakStartTime!.minute &&
  //           randomTimeInMinutes <=
  //               breakEndTime!.hour * 60 + breakEndTime!.minute) {
  //         randomTimeInMinutes = observationStartTime!.hour * 60 +
  //             observationStartTime!.minute +
  //             Random().nextInt(observationTimeRangeInMinutes(isNightShift));
  //       }
  //     }
  //   }
  //   var hour = (randomTimeInMinutes / 60).floor();
  //   var minute = (randomTimeInMinutes % 60);
  //   return TimeOfDay(hour: hour, minute: minute);
  // }

  int generateRandomTimeInMinutes(bool isNightShift) {
    return observationStartTime!.hour * 60 +
        observationStartTime!.minute +
        Random().nextInt(observationTimeRangeInMinutes(isNightShift));
  }

  List<int> randomTimesInMinutes(int observationsPerDay, bool isNightShift) {
    final List<int> randomTimes = [];

    for (int i = 0; i < observationsPerDay; i++) {
      var randomTimeInMinutes = generateRandomTimeInMinutes(isNightShift);

      // if (randomTimes.isEmpty) {
      //   randomTimes.add(randomTimeInMinutes);
      // } else if (randomTimes.length == 1) {
      //   //check first if randomTimeInMinutes is too close to the other generated random time.
      //   while ((randomTimeInMinutes - randomTimes[0]).abs() <=
      //       Tracker.minObservationInterval) {
      //     randomTimeInMinutes = generateRandomTimeInMinutes(isNightShift);
      //   }
      //   randomTimes.add(randomTimeInMinutes);
      //   randomTimes.sort();
      // } else {
      //   //check first if randomTimeInMinutes is too close to the other generated random times.
      //   bool invalidRandomTime = true;
      //   do {
      //     final index = randomTimes
      //         .indexWhere((element) => element >= randomTimeInMinutes);
      //     if (index == -1) {
      //       if (randomTimeInMinutes - randomTimes.last <=
      //           Tracker.minObservationInterval) {
      //         randomTimeInMinutes = generateRandomTimeInMinutes(isNightShift);
      //       } else {
      //         invalidRandomTime = false;
      //       }
      //     } else {
      //       if ((randomTimes[index] - randomTimeInMinutes).abs() <=
      //               Tracker.minObservationInterval &&
      //           (randomTimes[index - 1] - randomTimeInMinutes).abs() <=
      //               Tracker.minObservationInterval) {
      //         randomTimeInMinutes = generateRandomTimeInMinutes(isNightShift);
      //       } else {
      //         invalidRandomTime = false;
      //       }
      //     }
      //   } while (invalidRandomTime);

      //   randomTimes.add(randomTimeInMinutes);
      //   randomTimes.sort();
      // }

      randomTimes.add(randomTimeInMinutes);
    }
    return randomTimes;
  }
}

class DaysNotifier extends StateNotifier<List<Day>> {
  DaysNotifier()
      : super([
          const Day.sunday(0),
          const Day.monday(0),
          const Day.tuesday(0),
          const Day.wednesday(0),
          const Day.thursday(0),
          const Day.friday(0),
          const Day.saturday(0),
          const Day.anyday(0),
        ]);

  void resetDaysNotifier() {
    state = [
      const Day.sunday(0),
      const Day.monday(0),
      const Day.tuesday(0),
      const Day.wednesday(0),
      const Day.thursday(0),
      const Day.friday(0),
      const Day.saturday(0),
      const Day.anyday(0),
    ];
  }

  void loadDaysToNotifier(List<Day> days) {
    state = days;
  }

  void toggleIsSelected(DayId id) {
    state = [
      for (final day in state)
        if (id == day.id) day.copyWith(isSelected: !day.isSelected) else day
    ];
  }

  void _updateObservationStartTime(DayId id, Wrapped<TimeOfDay?>? timeOfDay) {
    state = [
      for (final day in state)
        if (id == day.id) day.copyWith(observationStartTime: timeOfDay) else day
    ];
  }

  void _updateObservationEndTime(DayId id, Wrapped<TimeOfDay?>? timeOfDay) {
    state = [
      for (final day in state)
        if (id == day.id) day.copyWith(observationEndTime: timeOfDay) else day
    ];
  }

  void _updateBreakStartTime(DayId id, Wrapped<TimeOfDay?>? timeOfDay) {
    state = [
      for (final day in state)
        if (id == day.id) day.copyWith(breakStartTime: timeOfDay) else day
    ];
  }

  void _updateBreakEndTime(DayId id, Wrapped<TimeOfDay?>? timeOfDay) {
    state = [
      for (final day in state)
        if (id == day.id) day.copyWith(breakEndTime: timeOfDay) else day
    ];
  }

  void updateTime(
      DayId id, Wrapped<TimeOfDay?>? timeOfDay, TimeCategory timeCategory) {
    switch (timeCategory) {
      case TimeCategory.observationStartTime:
        _updateObservationStartTime(id, timeOfDay);
        break;
      case TimeCategory.observationEndTime:
        _updateObservationEndTime(id, timeOfDay);
        break;
      case TimeCategory.breakStartTime:
        _updateBreakStartTime(id, timeOfDay);
        break;
      case TimeCategory.breakEndTime:
        _updateBreakEndTime(id, timeOfDay);
        break;
      default:
        () {};
        break;
    }
  }

  void updateTimeForAll(
      Wrapped<TimeOfDay?>? timeOfDay, TimeCategory timeCategory) {
    state = [
      for (final day in state)
        if (timeCategory == TimeCategory.observationStartTime)
          day.copyWith(observationStartTime: timeOfDay)
        else if (timeCategory == TimeCategory.observationEndTime)
          day.copyWith(observationEndTime: timeOfDay)
        else if (timeCategory == TimeCategory.breakStartTime)
          day.copyWith(breakStartTime: timeOfDay)
        else if (timeCategory == TimeCategory.breakEndTime)
          day.copyWith(breakEndTime: timeOfDay)
        else
          day
    ];
  }

  void resetTimeForAnyDay(TimeCategory timeCategory) {
    switch (timeCategory) {
      case TimeCategory.observationStartTime:
        state = [
          for (final day in state)
            if (day.id == DayId.anyday)
              day.copyWith(observationStartTime: const Wrapped.value(null))
            else
              day
        ];
        break;
      case TimeCategory.observationEndTime:
        state = [
          for (final day in state)
            if (day.id == DayId.anyday)
              day.copyWith(observationEndTime: const Wrapped.value(null))
            else
              day
        ];
        break;
      case TimeCategory.breakStartTime:
        state = [
          for (final day in state)
            if (day.id == DayId.anyday)
              day.copyWith(breakStartTime: const Wrapped.value(null))
            else
              day
        ];
        break;
      case TimeCategory.breakEndTime:
        state = [
          for (final day in state)
            if (day.id == DayId.anyday)
              day.copyWith(breakEndTime: const Wrapped.value(null))
            else
              day
        ];
        break;
      default:
        break;
    }
  }
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}

final daysProvider =
    StateNotifierProvider<DaysNotifier, List<Day>>((ref) => DaysNotifier());

final selectedDaysProvider =
    StateNotifierProvider<DaysNotifier, List<Day>>((ref) => DaysNotifier());
