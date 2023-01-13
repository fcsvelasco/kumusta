import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import '../styling/app_theme_data.dart';
import './page_heading.dart';

class CategoriesInfo extends ConsumerWidget {
  const CategoriesInfo({Key? key}) : super(key: key);

  Widget moodCategoriesContentBuilder(BuildContext context) {
    return Column(
      children: [
        const Text(
            'Switching this on allows you to categorize the moods as positive, neutral, or negative.'),
        const SizedBox(
          height: 16,
        ),
        const Text(
            'It is preferred to categorize the moods, but you may choose not to.'),
        const SizedBox(
          height: 20,
        ),
        ThemedButton(
          child: const Text('Okay'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget activityCategoriesContentBuilder(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SizedBox(
      height: mq.size.height * 0.4,
      child: ListView(
        children: [
          const Text(
            'Switching this on will allow you to categorize the activities as productive, necessary, or waste.',
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Productive',
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
                'These are activities that actually get the work done.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text('Also known as value-added activities.'),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Necessary',
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
                'These are activities that do not get the work done but are still needed.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text(
                'Also known as non-value-added and essential activities.'),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Waste',
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
                'These are activities that do not get the work done and should be minimized or eliminated.'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.check,
              color: Theme.of(context).accentColor,
            ),
            title: const Text(
                'Also known as non-value-added and non-essential activities.'),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
              'It is preferred to categorize your activities, but you may choose not to.'),
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
            const PageHeading(pageTitle: 'Categories'),
          ]),
          const Divider(
            thickness: 2,
          ),
          const SizedBox(
            height: 10,
          ),
          if (trackerMode == TrackerMode.activitySampling)
            activityCategoriesContentBuilder(context),
          if (trackerMode == TrackerMode.moodSampling)
            moodCategoriesContentBuilder(context),
        ],
      ),
    );
  }
}
