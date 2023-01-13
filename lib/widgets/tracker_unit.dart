import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/activity.dart';
import '../models/my_consumer_widget.dart';
import '../models/tracker.dart';
import '../services/database_helper.dart';
import '../styling/app_theme_data.dart';
import './view_tracker_details.dart';

class TrackerUnit extends MyConsumerWidget {
  TrackerUnit({required this.tracker, Key? key}) : super(key: key);

  final Tracker tracker;

  final trackerStatus = ['Current', 'Finished', 'Unfinished'];

  void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          content: Container(
            alignment: Alignment.center,
            height: 50,
            width: 50,
            child: LoadingAnimationWidget.discreteCircle(
              color: Theme.of(context).primaryColor,
              //secondRingColor: COLOR[2],
              thirdRingColor: COLOR[2],
              size: 50,
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteTracker(BuildContext context, WidgetRef ref) async {
    showLoadingDialog(context);

    await DatabaseHelper.instance.deleteTracker(tracker.id, ref).then((value) {
      Navigator.of(context).pop();
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
            context: context, child: const Text('Checker deleted!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
            context: context,
            child: const Text('Oops! Something went wrong.')));
      }
    });
  }

  Future<void> startDeleteTracker(BuildContext context, WidgetRef ref) async {
    // int? trackersCount = 0;
    // int? activitiesCount = 0;
    // int? observationsCount = 0;
    // int? daysCount = 0;
    await showValidationDialog(
      context: context,
      title: 'Delete Checker',
      description: 'Are you sure you want to delete this checker?',
      isForConfirmation: true,
    ).then((value) {
      if (value) {
        deleteTracker(context, ref);
      }
      //print(value);
    });
  }

  void showTrackerDetails(BuildContext context, WidgetRef ref) async {
    final activities =
        await DatabaseHelper.instance.getActivitiesListOfTracker(tracker.id);
    ref
        .read(resultsActivitiesProvider.notifier)
        .loadActivitiesToNotifier(activities);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: ViewTrackerDetails(
            tracker: tracker,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {},
      child: Card(
        //padding: EdgeInsets.all(5),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Theme.of(context).primaryColor, width: 5),
        //   borderRadius: const BorderRadius.all(Radius.circular(15)),
        //   color: COLOR[3],
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        margin: const EdgeInsets.all(5),
        child: ListTile(
          leading: Icon(
            tracker.status == TrackerStatus.current
                ? Icons.assignment_rounded
                : tracker.status == TrackerStatus.finished
                    ? Icons.assignment_turned_in_rounded
                    : Icons.assignment_late_rounded,
            color: Theme.of(context).accentColor,
            size: 30,
          ),
          title: Text(
            '${trackerStatus[tracker.status.index]} Checker',
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              '''From: ${DateFormat.yMMMd('en_US').format(tracker.startDate)}
To: ${DateFormat.yMMMd('en_US').format(tracker.endDate)}'''),
          trailing: tracker.status != TrackerStatus.current
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          showTrackerDetails(context, ref);
                        },
                        icon: Icon(
                          Icons.view_list_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () => startDeleteTracker(context, ref),
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
