import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_helper.dart';
import './tracker.dart';
import './dummy_data.dart';
import './observation.dart';

enum ActivityCategory { productive, necessary, waste, uncategorized }

class Activity {
  static const maxActivityNameLength = 15;
  static const maxDescriptionLength = 50;
  static const maxActivitiesCount = 15;
  static const categories = [
    ActivityCategory.productive,
    ActivityCategory.necessary,
    ActivityCategory.waste,
    ActivityCategory.uncategorized,
  ];

  final int trackerId;
  final String id;
  final String name;
  final String description;
  final ActivityCategory category;
  final int iconId;
  final int count;

  const Activity({
    required this.trackerId,
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.iconId,
    required this.count,
  });

  Activity copyWith(
      {int? trackerId,
      String? id,
      String? name,
      String? description,
      ActivityCategory? category,
      int? iconId,
      int? count}) {
    return Activity(
      trackerId: trackerId ?? this.trackerId,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      iconId: iconId ?? this.iconId,
      count: count ?? this.count,
    );
  }

  factory Activity.fromMap(Map<String, dynamic> json) {
    return Activity(
      trackerId: json['trackerId'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: ActivityCategory.values[json['category']],
      iconId: json['iconId'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackerId': trackerId,
      'id': id,
      'name': name,
      'description': description,
      'category': category.index,
      'iconId': iconId,
      'count': count,
    };
  }

  static String getCategory(
      ActivityCategory category, TrackerMode trackerMode) {
    if (trackerMode == TrackerMode.activitySampling) {
      {
        switch (category) {
          case ActivityCategory.productive:
            return 'Productive';
          case ActivityCategory.necessary:
            return 'Necessary';
          case ActivityCategory.waste:
            return 'Waste';
          case ActivityCategory.uncategorized:
            return 'Uncategorized';
          default:
            return '';
        }
      }
    } else {
      {
        switch (category) {
          case ActivityCategory.productive:
            return 'Positive';
          case ActivityCategory.necessary:
            return 'Neutral';
          case ActivityCategory.waste:
            return 'Negative';
          case ActivityCategory.uncategorized:
            return 'Uncategorized';
          default:
            return '';
        }
      }
    }
  }
}

class ActivitiesNotifier extends StateNotifier<List<Activity>> {
  ActivitiesNotifier() : super(ACTIVITIES);

  void loadActivitiesToNotifier(List<Activity> activities) {
    state = activities;
  }

  void addActivity(Activity activity) {
    state = [...state, activity];
  }

  void removeActivity(int trackerId, String id) {
    state = [
      for (final activity in state)
        if (activity.id != id && activity.trackerId == trackerId) activity
    ];
  }

  Future<void> updateActivity({
    required int trackerId,
    required String id,
    String? name,
    String? description,
    ActivityCategory? category,
    int? iconId,
    int? count,
  }) async {
    state = [
      for (final activity in state)
        if (activity.id == id && activity.trackerId == trackerId)
          activity.copyWith(
            name: name,
            description: description,
            category: category,
            iconId: iconId,
            count: count,
          )
        else
          activity
    ];

    DatabaseHelper.instance.updateActivity(
        trackerId, state.firstWhere((element) => element.id == id));
  }

  Future<void> initializeActivitiesCount(List<Observation> observations) async {
    state = [
      for (final activity in state)
        activity.copyWith(
            count: observations
                .where((o) => o.activityName == activity.name)
                .length)
    ];

    //print('Done initializing');
  }

  void incrementActivityCount(int trackerId, String name) {
    state = [
      for (final activity in state)
        if (activity.name == name && activity.trackerId == trackerId)
          activity.copyWith(count: activity.count + 1)
        else
          activity
    ];

    DatabaseHelper.instance.updateActivity(
        trackerId, state.firstWhere((element) => element.name == name));
  }
}

final activitiesProvider =
    StateNotifierProvider<ActivitiesNotifier, List<Activity>>(
        (ref) => ActivitiesNotifier());

final resultsActivitiesProvider =
    StateNotifierProvider<ActivitiesNotifier, List<Activity>>(
        (ref) => ActivitiesNotifier());
