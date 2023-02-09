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
    return Container(
      color: COLOR[0],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: ChartArea(),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: InformationTabsArea(
              startRecordObservation: widget.startRecordObservation,
            ),
          )
        ],
      ),
    );
  }
}
