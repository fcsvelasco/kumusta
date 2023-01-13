import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/tracker.dart';
import '../../styling/app_theme_data.dart';
import '../activities/activities_list.dart';
import '../activities/activity_unit.dart';
import '../current_checker/chart_area.dart';
import '../../styling/page_heading.dart';

class ViewTrackerDetails extends ConsumerWidget {
  ViewTrackerDetails({required this.tracker, Key? key}) : super(key: key);

  final Tracker tracker;

  final trackerStatus = ['Current', 'Finished', 'Unfinished'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);
    return Container(
      width: mq.size.width * 0.8,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        color: COLOR[0],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageHeading(
            pageTitle: '${trackerStatus[tracker.status.index]} Tracker',
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                  '''From: ${DateFormat.yMMMd('en_US').format(tracker.startDate)}
To: ${DateFormat.yMMMd('en_US').format(tracker.endDate)}'''),
            ],
          ),
          ChartArea(
            trackerId: tracker.id,
          ),
          const Divider(
            thickness: 2,
          ),
          SizedBox(
            height: mq.size.height * 0.25,
            child: ActivitiesList(
              activityUnitMode: ActivityUnitMode.showResults,
              resultsTrackerId: tracker.id,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ThemedButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
