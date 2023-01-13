import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/tracker.dart';
import '../../styling/page_heading.dart';
import '../../styling/app_theme_data.dart';
import '../../models/activity.dart';

class DeleteActivity extends ConsumerWidget {
  const DeleteActivity({required this.activity, Key? key}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerMode = ref.read(trackerProvider).trackerMode;
    return ThemedFormContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: PageHeading(
              pageTitle: trackerMode == TrackerMode.activitySampling
                  ? 'Delete Activity'
                  : 'Delete Mood',
            ),
          ),
          ListTile(
              title:
                  Text('Are you sure you want to delete "${activity.name}"?')),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ThemedButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: Consumer(builder: (context, ref, child) {
                return ThemedButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    ref.read(activitiesProvider.notifier).removeActivity(
                        ref.read(trackerProvider).id, activity.name);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      MySnackBar(
                        context: context,
                        child: Text(
                          trackerMode == TrackerMode.activitySampling
                              ? 'Activity deleted!'
                              : 'Mood deleted!',
                        ),
                      ),
                    );
                  },
                );
              })),
            ],
          )
        ],
      ),
    );
  }
}
