import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import './page_heading.dart';
import './tracker_unit.dart';

class TrackersList extends ConsumerWidget {
  const TrackersList({required this.trackerMode, Key? key}) : super(key: key);

  final TrackerMode trackerMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);
    final trackersList = ref
        .watch(trackersListProvider)
        .where((element) => element.trackerMode == trackerMode)
        .toList();
    if (trackersList.isNotEmpty) {
      trackersList.sort(((a, b) => b.id.compareTo(a.id)));
    }

    return Container(
      padding: const EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   borderRadius: const BorderRadius.all(Radius.circular(15)),
      //   border: Border.all(
      //     color: Theme.of(context).primaryColor,
      //     width: 5,
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: trackerMode == TrackerMode.activitySampling
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          PageHeading(
              pageTitle: trackerMode == TrackerMode.activitySampling
                  ? 'Productivity Checkers'
                  : 'Mood Checkers'),
          const Divider(
            thickness: 2,
          ),
          if (trackersList.isNotEmpty)
            SizedBox(
              height: mq.size.height * 0.225,
              child: ListView(
                children: <Widget>[
                  ...trackersList.map((e) => TrackerUnit(tracker: e)).toList()
                ],
              ),
            ),
          if (trackersList.isEmpty)
            Container(
              alignment: Alignment.center,
              height: mq.size.height * 0.225,
              child: ListTile(
                leading: Icon(
                  Icons.info_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
                title: Text(trackerMode == TrackerMode.activitySampling
                    ? 'This is where you\'ll find previous and current productivity checkers.'
                    : 'This is where you\'ll find previous and current mood checkers.'),
              ),
            ),
        ],
      ),
    );
  }
}
