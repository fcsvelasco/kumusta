import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksampler/styling/cutom_appbar.dart';

import '../models/activity.dart';
import '../models/tracker.dart';
import '../widgets/activity_unit.dart';
import './verify_settings_page.dart';
import '../widgets/page_heading.dart';
import '../widgets/activities_settings.dart';
import '../styling/app_theme_data.dart';

class SetActivitiesPage extends ConsumerWidget {
  Future<bool> showValidationDialog(BuildContext context, String title,
      String description, bool isForConfirmation) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: ValidationDialog(
            title: title,
            description: description,
            //height: 200,
            width: MediaQuery.of(context).size.width * 0.8,
            isForConfirmation: isForConfirmation,
          ),
        );
      },
    );
  }

  Future<bool> goodActivitiesInput(BuildContext context, WidgetRef ref) async {
    final trackerMode = ref.read(trackerProvider).trackerMode;
    final activities = ref.read(activitiesProvider);
    final uncategorizedActivities = activities
        .where((element) => element.category == ActivityCategory.uncategorized)
        .toList();
    final tracker = ref.read(trackerProvider);
    if (activities.length <= 1) {
      showValidationDialog(
        context,
        trackerMode == TrackerMode.activitySampling
            ? 'Missing Activities'
            : 'Missing Moods!',
        trackerMode == TrackerMode.activitySampling
            ? 'There should be at least two (2) activities added.'
            : 'There should be at least two (2) moods added.',
        false,
      );
      return false;
    }

    if (tracker.isActivitiesCategorized && uncategorizedActivities.isNotEmpty) {
      showValidationDialog(
        context,
        trackerMode == TrackerMode.activitySampling
            ? 'Uncategorized Activities'
            : 'Uncategorized Moods',
        trackerMode == TrackerMode.activitySampling
            ? 'There is at least one uncategorized activity. Kindly choose a category for the activity or unselect "Categorize activities" option.'
            : 'There is at least one uncategorized mood. Kindly choose a category for the mood or unselect "Categorize moods" option.',
        false,
      );
      return false;
    }
    return true;
  }

  void goToNextPage(BuildContext context, WidgetRef ref) {
    goodActivitiesInput(context, ref).then((value) {
      if (value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerifySettingsPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerMode = ref.read(trackerProvider).trackerMode;
    final mq = MediaQuery.of(context);
    final appBar = CustomAppBar();
    return Scaffold(
      appBar: appBar,
      body: Container(
        color: COLOR[0],
        //padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            ListView(
              children: <Widget>[
                Container(
                  // height: (mq.size.height -
                  //         mq.padding.top -
                  //         appBar.preferredSize.height) *
                  //     0.25,
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 30,
                    right: 30,
                    bottom: 30,
                  ),
                  //margin: const EdgeInsets.only(right: 30),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  alignment: Alignment.topLeft,
                  child: PageHeading(
                    pageTitle: trackerMode == TrackerMode.activitySampling
                        ? 'Step 2: Specify your activities!'
                        : 'Step 2: Specify possible moods!',
                    pageDescription: trackerMode == TrackerMode.activitySampling
                        ? '''In this section, you provide your daily activities or the tasks to be considered.

Once monitoring has started, you can still add activities, but you can no longer edit or delete them.'''
                        : '''In this section, you indicate different moods to be considered. An initial list is provided, but you can adjust to your liking.

Once monitoring has started, you can still add moods, but you can no longer edit or delete them.''',
                    pageTitleColor: Colors.white,
                    pageDescriptionColor: Colors.white,
                  ),
                ),
                Container(
                  height: (mq.size.height -
                          mq.padding.top -
                          appBar.preferredSize.height) *
                      0.60,
                  padding: const EdgeInsets.all(10.0),
                  child:
                      const ActivitiesSettings(mode: ActivityUnitMode.editing),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ThemedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ThemedButton(
                        onPressed: () {
                          goToNextPage(context, ref);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
