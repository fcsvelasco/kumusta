import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/tracker.dart';
import './set_schedule_page.dart';
import '../widgets/start_new_tracker_dialog.dart';
import './tabs_page.dart';
import '../styling/app_theme_data.dart';
import '../services/database_helper.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({this.payload, Key? key}) : super(key: key);

  String? payload;
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.payload != null && widget.payload == 'tabs_page') {
        loadCurrentData(context);
      } else if (await DatabaseHelper.instance.isWithCurrentTracker()) {
        loadCurrentData(context);
      } else if (await DatabaseHelper.instance.isWithFinishedTracker()) {
        loadLatestFinishedData(context);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> loadCurrentData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    _timer = Timer(const Duration(seconds: 3), () async {
      await DatabaseHelper.instance
          .loadCurrentDataToNotifiers(ref)
          .then((value) =>
              ref.read(trackerProvider).updateObservationsOnLoad(ref))
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const TabsPage()));
      });
    });
  }

  Future<void> loadLatestFinishedData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    _timer = Timer(const Duration(seconds: 3), () async {
      await DatabaseHelper.instance
          .loadLatestFinishedDataToNotifiers(ref)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const TabsPage()));
      });
    });
  }

  void startCreateNewTracker() async {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
            contentPadding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: StartNewTrackerDialog(
              isFromHomePage: true,
            ));
      },
    ).then((value) {
      if (value == null) {
        return;
      }
      if (value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SetSchedulePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      //backgroundColor: Theme.of(context).primaryColor,
      //backgroundColor: COLOR[0],
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: mq.size.height * 0.40,
            ),
            // const Text(
            //   'Kumusta',
            //   style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold),
            // ),
            SizedBox(
              width: mq.size.width * 0.6,
              child: Image.asset(
                'assets/images/logo-appbar.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            // ThemedButton(
            //   child: const Text('Load Data'),
            //   onPressed: () {
            //     loadData(context);
            //   },
            // ),
            // ThemedButton(
            //   child: const Text('Create Activity Tracker'),
            //   onPressed: () =>
            //       startTrackerSetup(context, TrackerMode.activitySampling),
            // ),
            // ThemedButton(
            //   child: const Text('Create Mood Tracker'),
            //   onPressed: () =>
            //       startTrackerSetup(context, TrackerMode.moodSampling),
            // ),

            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              child: _isLoading
                  ? LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).accentColor,
                      //rightDotColor: COLOR[0],

                      //thirdRingColor: COLOR[0],
                      size: 20,
                    )
                  : null,
            ),
            SizedBox(
              height: mq.size.height * 0.15,
            ),
            if (!_isLoading)
              ThemedButton(
                onPressed: () {
                  startCreateNewTracker();
                },
                color: Theme.of(context).accentColor,
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            // ThemedButton(
            //   child: const Text('Delete Database'),
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
