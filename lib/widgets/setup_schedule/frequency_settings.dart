import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styling/my_consumer_widget.dart';
import '../../models/tracker.dart';

class FrequencySettings extends MyConsumerWidget {
  const FrequencySettings({Key? key}) : super(key: key);

  void showFrequencyInfo(BuildContext context) {
    showValidationDialog(
      context: context,
      title: 'Frequency',
      isForConfirmation: false,
      icon: Icon(
        Icons.info_rounded,
        color: Theme.of(context).primaryColor,
      ),
      descriptionWidget: FrequencyInfo(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackerFrequency = ref.watch(trackerProvider).trackerFrequency;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Frequency',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => showFrequencyInfo(context),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              leading: Radio(
                value: TrackerFrequency.relaxed,
                groupValue: trackerFrequency,
                onChanged: (_) {
                  ref
                      .read(trackerProvider.notifier)
                      .setFrequency(TrackerFrequency.relaxed);
                },
              ),
              title: const Text('Relaxed'),
            ),
            ListTile(
              leading: Radio(
                value: TrackerFrequency.moderate,
                groupValue: trackerFrequency,
                onChanged: (_) {
                  ref
                      .read(trackerProvider.notifier)
                      .setFrequency(TrackerFrequency.moderate);
                },
              ),
              title: const Text('Moderate'),
            ),
            ListTile(
              leading: Radio(
                value: TrackerFrequency.frequent,
                groupValue: trackerFrequency,
                onChanged: (_) {
                  ref
                      .read(trackerProvider.notifier)
                      .setFrequency(TrackerFrequency.frequent);
                },
              ),
              title: const Text('Frequent'),
            ),
          ],
        ),
      ),
    );
  }
}

class FrequencyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('This is where you set how often the self-checks occur.'),
        const SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Relaxed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //fontStyle: FontStyle.italic,
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  color: Theme.of(context).accentColor,
                ),
              ),
              const TextSpan(
                text: ' - self-checks will occur every hour on average.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Moderate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //fontStyle: FontStyle.italic,
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  color: Theme.of(context).accentColor,
                ),
              ),
              const TextSpan(
                text: ' - self-checks will occur every 30 minutes on average.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Frequent',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  //fontStyle: FontStyle.italic,
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  color: Theme.of(context).accentColor,
                ),
              ),
              const TextSpan(
                text: ' - self-checks will occur every 10 minutes on average.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
            'More frequent self-checks will lead to a more accurate monitoring but may cause inconvenience on your part. Less frequent self-checks will require less effort on your part but will give you less accurate results.'),
      ],
    );
  }
}
