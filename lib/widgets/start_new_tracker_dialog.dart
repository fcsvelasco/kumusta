import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import '../services/database_helper.dart';
import '../styling/app_theme_data.dart';
import './page_heading.dart';

class StartNewTrackerDialog extends ConsumerStatefulWidget {
  const StartNewTrackerDialog({required this.isFromHomePage, Key? key})
      : super(key: key);

  final bool isFromHomePage;

  @override
  ConsumerState<StartNewTrackerDialog> createState() =>
      _StartNewTrackerDialogState();
}

class _StartNewTrackerDialogState extends ConsumerState<StartNewTrackerDialog> {
  TrackerMode? _mode = TrackerMode.moodSampling;

  Future<void> startNewTrackerSetup(Tracker tracker) async {
    if (tracker.status == TrackerStatus.current && !widget.isFromHomePage) {
      await DatabaseHelper.instance
          .unfinishTracker(tracker)
          .then((_) => Tracker.startNewTrackerSetup(ref, _mode!));
    } else {
      Tracker.startNewTrackerSetup(ref, _mode!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracker = ref.read(trackerProvider);
    final mq = MediaQuery.of(context);
    return ThemedFormContainer(
      width: mq.size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const PageHeading(pageTitle: 'Start New Checker'),
          const SizedBox(
            height: 10,
          ),
          if (widget.isFromHomePage)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Kumusta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontStyle: FontStyle.italic,
                      fontSize: 16,
                      fontFamily: 'Quicksand',
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' helps you monitor your mood or productivity by occasionally reminding you to check how you feel or what you are doing.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Quicksand',
                    ),
                  ),
                ],
              ),
            ),
          if (widget.isFromHomePage)
            const SizedBox(
              height: 10,
            ),
          if (widget.isFromHomePage)
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Set up your checker',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                    TextSpan(
                      text: ' in 3 easy steps!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        //fontStyle: FontStyle.italic,
                        fontSize: 16,
                        fontFamily: 'Quicksand',
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.isFromHomePage)
            const SizedBox(
              height: 20,
            ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(widget.isFromHomePage
                ? 'But first, choose your checker type:'
                : 'Choose checker type:'),
          ),
          ListTile(
            title: const Text('Mood Checker'),
            leading: Radio<TrackerMode>(
              groupValue: _mode,
              value: TrackerMode.moodSampling,
              onChanged: (val) {
                setState(() {
                  _mode = val;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Productivity Checker'),
            leading: Radio<TrackerMode>(
              groupValue: _mode,
              value: TrackerMode.activitySampling,
              onChanged: (val) {
                setState(() {
                  _mode = val;
                });
              },
            ),
          ),
          if (tracker.status == TrackerStatus.current && !widget.isFromHomePage)
            const Divider(
              thickness: 2,
            ),
          if (tracker.status == TrackerStatus.current && !widget.isFromHomePage)
            ListTile(
              leading: Icon(
                Icons.warning_rounded,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                  'Are you sure you want to start a new checker? Your current checker will be stopped.'),
            ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ThemedButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false)),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ThemedButton(
                    child: const Text('Continue'),
                    onPressed: () {
                      startNewTrackerSetup(tracker)
                          .then((value) => Navigator.of(context).pop(true));
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
