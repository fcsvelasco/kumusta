import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../styling/cutom_appbar.dart';
import '../models/tracker.dart';
import '../widgets/schedule_summary.dart';
import '../services/database_helper.dart';
import './tabs_page.dart';
import '../styling/app_theme_data.dart';
import '../widgets/activities_list.dart';
import '../widgets/activity_unit.dart';
import '../widgets/page_heading.dart';

class VerifySettingsPage extends ConsumerWidget {
  const VerifySettingsPage({Key? key}) : super(key: key);

  void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).primaryColor,
                //secondRingColor: COLOR[2],
                //thirdRingColor: COLOR[2],
                size: 50,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBar = CustomAppBar();
    final trackerMode = ref.read(trackerProvider).trackerMode;

    return Scaffold(
      appBar: appBar,
      body: Container(
        color: COLOR[0],
        //padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              //height: (mq.size.height - mq.padding.top) * 0.15,
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
              child: PageHeading(
                pageTitle: 'Step 3: Verify!',
                pageDescription: trackerMode == TrackerMode.activitySampling
                    ? 'In this section, you verify the schedule and activities you have provided. Make sure you are okay with the schedule and activities before clicking "Submit".'
                    : 'In this section, you verify the schedule and moods you have provided. Make sure you are okay with the schedule and moods before clicking "Submit".',
                pageTitleColor: Colors.white,
                pageDescriptionColor: Colors.white,
              ),
            ),
            //VerifySchedule(_days),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: ScheduleSummary(isForVerifySettingsPage: true),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeading(
                        pageTitle: trackerMode == TrackerMode.activitySampling
                            ? 'Activities'
                            : 'Moods',
                        pageTitleColor: Theme.of(context).accentColor,
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      ActivitiesList(
                        activityUnitMode: ActivityUnitMode.verify,
                      ),
                    ],
                  ),
                ),
              ),
            ),

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
                    showLoadingDialog(context);
                    DatabaseHelper.instance
                        .saveAndStartTracking(ref)
                        .then((isSuccessful) {
                      if (isSuccessful) {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TabsPage()),
                            (Route route) => false);
                      }
                    });
                  },
                  child: const Text(
                    'Submit',
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

            // ThemedButton(
            //   child: Text('Delete Database'),
            //   onPressed: () {
            //     DatabaseHelper.instance.deleteDatabase();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
