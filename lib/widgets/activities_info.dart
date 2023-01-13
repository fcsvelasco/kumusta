import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import '../styling/app_theme_data.dart';
import './page_heading.dart';

class ActivitiesInfo extends ConsumerWidget {
  const ActivitiesInfo({Key? key}) : super(key: key);

  Widget moodContentBuilder(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Once tracking has started, during random self-checks, you will be asked about how you feel at that moment. You shall answer by choosing among the list of moods that you have provided here.'),
        const SizedBox(
          height: 16,
        ),
        const Text(
            'An initial list is provided, but feel free to add, edit, or delete items.'),
        const SizedBox(
          height: 16,
        ),
        const Text(
          'You can provide up to ${Tracker.maxActivities} moods.',
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          child: ThemedButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  Widget activitiesContentBuilder(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SizedBox(
      height: mq.size.height * 0.4,
      child: ListView(
        children: [
          const Text(
              'Once tracking has started, during random self-checks, you will be asked about what you are doing at that moment. You shall answer by choosing among the list of activities that you have provided here.'),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Which activities should you add?',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
              'It\'s up to you! What are your activities at work or during your usual day?'),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Here are few examples:',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text(
                'If you are a teacher, you can add "Teaching", "Preparing for class", "Checking homeworks", and others.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text(
                'If you are a nurse: "Taking patient vitals", "Assisting with physical exam", "Administering medication", and others.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text(
                'If you are a student: "Studying", "Completing schoolworks", "Procrastinating", and others.'),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'You can also add activities like:',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text('Resting'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text('In a meeting'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text('Waiting'),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
              'An initial list of general activities is provided, but feel free to add, edit, or delete items.'),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'You can provide up to ${Tracker.maxActivities} activities.',
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ThemedButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerMode = ref.read(trackerProvider).trackerMode;
    final mq = MediaQuery.of(context);
    return ThemedFormContainer(
      width: mq.size.width * 0.8,
      //height: mq.size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Icon(
              Icons.info_rounded,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              width: 20,
            ),
            PageHeading(
              pageTitle: trackerMode == TrackerMode.activitySampling
                  ? 'Activities'
                  : 'Moods',
            ),
          ]),
          const Divider(
            thickness: 2,
          ),
          const SizedBox(
            height: 10,
          ),
          if (trackerMode == TrackerMode.activitySampling)
            activitiesContentBuilder(context),
          if (trackerMode == TrackerMode.moodSampling)
            moodContentBuilder(context),
        ],
      ),
    );
  }
}
