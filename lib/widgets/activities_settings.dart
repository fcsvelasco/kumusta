import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './activities_info.dart';
import './categories_info.dart';
import '../models/activity.dart';
import './add_activity_form.dart';
import '../models/tracker.dart';
import './activities_list.dart';
import '../styling/app_theme_data.dart';
import './activity_unit.dart';

class ActivitiesSettings extends ConsumerWidget {
  const ActivitiesSettings({required this.mode, Key? key}) : super(key: key);

  final ActivityUnitMode mode;

  void _startAddActivity(
      BuildContext context, WidgetRef ref, TrackerMode trackerMode) {
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
              hasStartedTracking: false,
            ),
          );
        },
      );
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

  void showInfo(
      {required BuildContext context, required bool isForActivities}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          content:
              isForActivities ? const ActivitiesInfo() : const CategoriesInfo(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final tracker = ref.watch(trackerProvider);
    final trackerMode = ref.read(trackerProvider).trackerMode;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Stack(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      trackerMode == TrackerMode.activitySampling
                          ? 'Activities'
                          : 'Moods',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () =>
                          showInfo(context: context, isForActivities: true),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              Container(
                //height: constraints.maxHeight * 0.08,
                child: Row(
                  children: <Widget>[
                    Consumer(builder: (context, ref, child) {
                      final tracker = ref.watch(trackerProvider);
                      return Switch(
                        value: tracker.isActivitiesCategorized,
                        onChanged: (val) {
                          ref
                              .read(trackerProvider.notifier)
                              .toggleIsActivitiesCategorized(val);
                        },
                      );
                    }),
                    Text(
                      trackerMode == TrackerMode.activitySampling
                          ? 'Categorize Activities'
                          : 'Categorize Moods',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () =>
                          showInfo(context: context, isForActivities: false),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ActivitiesList(
                  activityUnitMode: ActivityUnitMode.editing,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).accentColor),
                      ),
                      onPressed: () =>
                          _startAddActivity(context, ref, trackerMode),
                      child: Text(
                        trackerMode == TrackerMode.activitySampling
                            ? 'Add Activity'
                            : 'Add Mood',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
