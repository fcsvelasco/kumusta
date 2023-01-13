import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';

enum ObservationStatus {
  waiting,
  recordNow,
  recorded,
  missed,
  updated,
}

class Observation {
  static const totalObservations = 1000;
  static const recordNowDuration = 3;

  final int trackerId;
  final String id;
  final DateTime dateTime;
  final String? activityName;
  final ObservationStatus status;
  final DateTime? dateTimeUpdated;

  const Observation({
    required this.trackerId,
    required this.id,
    required this.dateTime,
    required this.activityName,
    required this.status,
    this.dateTimeUpdated,
  });

  Observation copyWith({
    int? trackerId,
    String? id,
    DateTime? dateTime,
    String? activityName,
    ObservationStatus? status,
    DateTime? dateTimeUpdated,
  }) {
    return Observation(
      trackerId: trackerId ?? this.trackerId,
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      activityName: activityName ?? this.activityName,
      status: status ?? this.status,
      dateTimeUpdated: dateTimeUpdated ?? this.dateTimeUpdated,
    );
  }

  factory Observation.fromMap(Map<String, dynamic> json) {
    return Observation(
      trackerId: json['trackerId'],
      id: json['observationId'],
      dateTime: DateTime.parse(json['dateTime']),
      activityName: json['activityName'],
      status: ObservationStatus.values[json['status']],
      dateTimeUpdated: DateTime.tryParse(json['dateTimeUpdated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackerId': trackerId,
      'observationId': id,
      'dateTime': dateTime.toIso8601String(),
      'activityName': activityName,
      'status': status.index,
      'dateTimeUpdated':
          dateTimeUpdated == null ? '' : dateTimeUpdated!.toIso8601String(),
    };
  }
}

class ObservationsNotifier extends StateNotifier<List<Observation>> {
  ObservationsNotifier() : super([]);

  void loadObservationsToNotifier(List<Observation> observations) {
    state = observations;
  }

  Future<void> updateObservation({
    required int trackerId,
    required String id,
    DateTime? dateTime,
    String? activityName,
    ObservationStatus? status,
    DateTime? dateTimeUpdated,
  }) async {
    try {
      state = [
        for (final obs in state)
          if (obs.id == id && obs.trackerId == trackerId)
            obs.copyWith(
              dateTime: dateTime,
              activityName: activityName,
              status: status,
              dateTimeUpdated: dateTimeUpdated,
            )
          else
            obs
      ];

      await DatabaseHelper.instance.updateObservation(
          trackerId, state.firstWhere((element) => element.id == id));
    } catch (e) {
      //print('observation.updateObservation() error: $e');
    }
  }
}

final observationsProvider =
    StateNotifierProvider<ObservationsNotifier, List<Observation>>(
        (ref) => ObservationsNotifier());
