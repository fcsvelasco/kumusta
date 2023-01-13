import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import '../models/activity.dart';
import './activity_unit.dart';

class ActivitiesList extends ConsumerWidget {
  //const ActivitiesList({Key? key}) : super(key: key);

  final ActivityUnitMode activityUnitMode;

  final Function? selectActivity;
  final Function? unselectActivity;
  final Activity? selectedActivity;
  final int? resultsTrackerId;

  final dataKey = GlobalKey();

  //final dataKey = GlobalKey();

  ActivitiesList({
    required this.activityUnitMode,
    this.selectActivity,
    this.unselectActivity,
    this.selectedActivity,
    this.resultsTrackerId,
    Key? key,
  }) : super(key: key);

  Widget categoryColumnBuilder(
      ActivityCategory category, Tracker tracker, List<Activity> activities) {
    if (activities.where((a) => a.category == category).isEmpty) {
      return (Container());
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            tracker.categories[category]!,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          ...activities.map((act) {
            return act.category == category
                ? activityUnitMode == ActivityUnitMode.recording
                    ? ActivityUnit(
                        key: act == selectedActivity ? dataKey : null,
                        mode: activityUnitMode,
                        activity: act,
                        selectActivity: selectActivity,
                        unselectActivity: unselectActivity,
                        isSelected: act == selectedActivity,
                      )
                    : ActivityUnit(
                        activity: act,
                        mode: activityUnitMode,
                      )
                : Container();
          }).toList(),
          const Divider(
            thickness: 2,
          ),
        ],
      );
    }
  }

  List<Widget> listBuilder(WidgetRef ref) {
    late final Tracker tracker;
    late final List<Activity> activities;
    if (activityUnitMode == ActivityUnitMode.showResults) {
      tracker = ref
          .watch(trackersListProvider)
          .firstWhere((element) => element.id == resultsTrackerId, orElse: () {
        return Tracker(
          id: 999,
          isSameTimeForAllDays: true,
          isWithBreakTime: false,
          isNightShift: false,
          isActivitiesCategorized: true,
          trackerMode: TrackerMode.activitySampling,
          status: TrackerStatus.unfinished,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        );
      });
      activities = ref.watch(resultsActivitiesProvider);
    } else {
      tracker = ref.watch(trackerProvider);
      activities = ref.watch(activitiesProvider);
    }

    return tracker.isActivitiesCategorized
        ? <Widget>[
            categoryColumnBuilder(
                ActivityCategory.productive, tracker, activities),
            categoryColumnBuilder(
                ActivityCategory.necessary, tracker, activities),
            categoryColumnBuilder(ActivityCategory.waste, tracker, activities),
            categoryColumnBuilder(
                ActivityCategory.uncategorized, tracker, activities),
          ]
        : <Widget>[
            ...activities.map((act) {
              if (activityUnitMode == ActivityUnitMode.recording) {
                return ActivityUnit(
                  key: act == selectedActivity ? dataKey : null,
                  mode: activityUnitMode,
                  activity: act,
                  selectActivity: selectActivity,
                  unselectActivity: unselectActivity,
                  isSelected: act == selectedActivity,
                );
              } else {
                return ActivityUnit(
                  mode: activityUnitMode,
                  activity: act,
                );
              }
            }).toList()
          ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: activityUnitMode == ActivityUnitMode.verify
          ? Column(
              children: listBuilder(ref),
            )
          : SingleChildScrollView(
              child: Column(
                children: listBuilder(ref),
              ),
            ),
    );
  }
}
