import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracker.dart';
import '../models/observation.dart';
import './observations_list.dart';
import './activities_list.dart';
import './activity_unit.dart';

enum Tabs {
  activities,
  observations,
}

class InformationTabsArea extends StatefulWidget {
  const InformationTabsArea({
    required this.startRecordObservation,
    Key? key,
  }) : super(key: key);

  final Function startRecordObservation;

  @override
  State<InformationTabsArea> createState() => _InformationTabsAreaState();
}

class _InformationTabsAreaState extends State<InformationTabsArea> {
  var _selectedTab = Tabs.activities;

  void selectTab(Tabs tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(30.0),
      // ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.white70,
        //color: Colors.orange[400],
        //color: Theme.of(context).primaryColor,
      ),
      //elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: constraints.maxHeight * 0.1,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final tracker = ref.read(trackerProvider).trackerMode;
                          return InkWell(
                            onTap: () => selectTab(Tabs.activities),
                            child: _selectedTab == Tabs.activities
                                ? Text(
                                    tracker == TrackerMode.activitySampling
                                        ? 'Activities'
                                        : 'Moods',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      //color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    tracker == TrackerMode.activitySampling
                                        ? 'Activities'
                                        : 'Moods',
                                    textAlign: TextAlign.center,
                                    // style: TextStyle(
                                    //   //color: Theme.of(context).primaryColor,
                                    //   color: Colors.black54,
                                    // ),
                                  ),
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 2,
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Consumer(builder: ((context, ref, child) {
                        return InkWell(
                          onTap: () => selectTab(Tabs.observations),
                          child: ref
                                  .watch(observationsProvider)
                                  .where((o) =>
                                      o.status == ObservationStatus.missed)
                                  .isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      'Self-Checks',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.assignment_late_outlined,
                                      color: Colors.red,
                                    )
                                  ],
                                )
                              : _selectedTab == Tabs.observations
                                  ? Text(
                                      'Self-Checks',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        //color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Text(
                                      'Self-Checks',
                                      textAlign: TextAlign.center,
                                    ),
                        );
                      })),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              if (_selectedTab == Tabs.activities)
                Container(
                  height: constraints.maxHeight * 0.8,
                  padding: const EdgeInsets.all(10),
                  child: ActivitiesList(
                    activityUnitMode: ActivityUnitMode.viewing,

                    //startEditActivityHandler: () {},
                  ),
                ),
              if (_selectedTab == Tabs.observations)
                SizedBox(
                  height: constraints.maxHeight * 0.8,
                  child: ObservationsList(
                    startRecordObservation: widget.startRecordObservation,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
