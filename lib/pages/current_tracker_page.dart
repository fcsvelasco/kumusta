import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/current_checker/information_tabs_area.dart';
import '../widgets/current_checker/chart_area.dart';
import '../styling/app_theme_data.dart';

class CurrentTrackerPage extends ConsumerStatefulWidget {
  const CurrentTrackerPage({required this.startRecordObservation, Key? key})
      : super(key: key);

  final Function startRecordObservation;

  @override
  ConsumerState<CurrentTrackerPage> createState() => _CurrentTrackerPageState();
}

class _CurrentTrackerPageState extends ConsumerState<CurrentTrackerPage> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final appBar = AppBar(
      title: const Text('Mood Tracker'),
      centerTitle: true,
    );

    return Container(
      color: COLOR[0],
      //color: Colors.orange[50],
      //padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Container(
          //   height: (mq.size.height -
          //           mq.padding.top -
          //           appBar.preferredSize.height -
          //           kBottomNavigationBarHeight) *
          //       0.10,
          //   child: const PageHeading(
          //     pageTitle: 'Good day!',
          //     //pageDescription: 'Tracker id: ${ref.watch(trackerProvider).id}',
          //   ),
          // ),
          Container(
            // height: (mq.size.height -
            //         mq.padding.top -
            //         appBar.preferredSize.height -
            //         kBottomNavigationBarHeight) *
            //     0.5,
            padding: const EdgeInsets.all(10),
            child: ChartArea(),
          ),
          SizedBox(
            height: (mq.size.height -
                    mq.padding.top -
                    appBar.preferredSize.height -
                    kBottomNavigationBarHeight) *
                0.45,
            //padding: const EdgeInsets.all(10),

            child: InformationTabsArea(
              startRecordObservation: widget.startRecordObservation,
            ),
          )
        ],
      ),
    );
  }
}
