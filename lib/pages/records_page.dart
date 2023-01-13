import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksampler/services/notification_helper.dart';

import '../models/tracker.dart';
import '../styling/app_theme_data.dart';
import '../widgets/trackers_list.dart';

class RecordsPage extends ConsumerStatefulWidget {
  RecordsPage({
    //required this.finishTracking,
    Key? key,
  }) : super(key: key);

  //Function finishTracking;

  @override
  ConsumerState<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends ConsumerState<RecordsPage> {
  // int trackersCount = 0;
  // int activitiesCount = 0;
  // int observationsCount = 0;
  // int daysCount = 0;
  // late final LocalNotificationHelper notificationHelper;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   notificationHelper = LocalNotificationHelper();
  //   notificationHelper.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(10),
      color: COLOR[0],
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),
              color: Colors.white70,
            ),
            child: const TrackersList(
              trackerMode: TrackerMode.moodSampling,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20, right: 20),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: Colors.white70,
            ),
            child: const TrackersList(
              trackerMode: TrackerMode.activitySampling,
            ),
          ),
          // Text('Trackers table rows: $trackersCount'),
          // Text('Activities table rows: $activitiesCount'),
          // Text('Observations table rows: $observationsCount'),
          // Text('Days table rows: $daysCount'),
          // ThemedButton(
          //     child: Text('Finish Current Tracker'),
          //     onPressed: () => widget.finishTracking()),
          // ThemedButton(
          //   child: const Text('Send notification'),
          //   onPressed: () {
          //     notificationHelper.setScheduledNotification(
          //       id: 999,
          //       title: 'Sample',
          //       body: 'Sample',
          //       dateTime: DateTime.now().add(const Duration(seconds: 3)),
          //       payload: 'tabs_page',
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
