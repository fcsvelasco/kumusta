import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './choose_icon_form.dart';
import '../models/activity.dart';
import '../models/tracker.dart';
import '../styling/app_theme_data.dart';

class ViewActivityDetails extends ConsumerWidget {
  const ViewActivityDetails({
    required this.activity,
    Key? key,
  }) : super(key: key);

  final Activity activity;

  void startEditIcon(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: ((context) {
        return const ChooseIconForm();
      }),
    ).then((value) {
      if (value != null) {
        ref.read(activitiesProvider.notifier).updateActivity(
              trackerId: activity.trackerId,
              id: activity.id,
              iconId: value,
            );
        ScaffoldMessenger.of(context).showSnackBar(
          MySnackBar(
            context: context,
            child: const Text('Icon updated!'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);
    final tracker = ref.read(trackerProvider);
    final recordedObservations = tracker.recordedObservationsCount(ref);
    //final trackerMode = ref.read(trackerProvider).trackerMode;
    return ThemedFormContainer(
      width: mq.size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // PageHeading(
          //   pageTitle: tracker.trackerMode == TrackerMode.activitySampling
          //       ? 'Activity Details'
          //       : 'Mood Details',
          // ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   child: Text('Tracker id: ${activity.trackerId}'),
          // ),
          ListTile(
            title: Text(
              activity.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                startEditIcon(context, ref);
              },
              child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    //color: Colors.white,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2),
                  ),
                  child: Icon(
                    ICONS[ref
                        .watch(activitiesProvider)
                        .firstWhere((element) => element.name == activity.name)
                        .iconId],
                    color: Theme.of(context).accentColor,
                  )),
            ),
          ),
          if (activity.description != '')
            ListTile(
              leading: Icon(
                Icons.check_rounded,
                color: Theme.of(context).accentColor,
              ),
              title: Text('Description: ${activity.description}'),
            ),
          ListTile(
            leading: Icon(
              Icons.check_rounded,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Category: ${Activity.getCategory(
              activity.category,
              tracker.trackerMode,
            )}'),
          ),
          ListTile(
            leading: Icon(
              Icons.check_rounded,
              color: Theme.of(context).accentColor,
            ),
            title: Text(recordedObservations > 0
                ? 'Count: ${activity.count} out of $recordedObservations (${(100 * activity.count / recordedObservations).toStringAsFixed(1)}%)'
                : 'Count: ${activity.count}'),
          ),
          ThemedButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
