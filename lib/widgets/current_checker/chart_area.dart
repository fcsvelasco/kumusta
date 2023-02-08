import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/day.dart';
import '../../styling/page_heading.dart';
import '../../models/tracker.dart';
import '../../models/activity.dart';
import '../../styling/app_theme_data.dart';

class ChartArea extends ConsumerStatefulWidget {
  ChartArea({
    this.trackerId,
    Key? key,
  }) : super(key: key);

  final int? trackerId;

  @override
  ConsumerState<ChartArea> createState() => _ChartAreaState();
}

class _ChartAreaState extends ConsumerState<ChartArea> {
  final _maxLegendStringLength = 15;
  final _maxLegendItems = 6;

  //var _init = true;
  bool _showCategoriesChart = false;

  Map<String, double> _activitiesDataMap = {
    'Sample': 3,
    'Sampe ulit': 4,
  };
  Map<String, double> _categoriesDataMap = {
    'Sample': 3,
    'Sampe ulit': 4,
  };

  void updateActivitiesDataMap(List<Activity> activities) {
    Map<String, double> dataMap = {};
    List<Activity> activitiesCopy = [];
    for (final a in activities) {
      activitiesCopy.add(a);
      //print('Activity ${activities.indexOf(a)}: ${a.name}');
    }
    if (activitiesCopy.length <= _maxLegendItems) {
      for (final a in activities) {
        if (a.name.length >= _maxLegendStringLength) {
          dataMap['${a.name.substring(0, _maxLegendStringLength - 5)} ...'] =
              a.count.toDouble();
        } else {
          dataMap[a.name] = a.count.toDouble();
        }
      }
    } else {
      activitiesCopy.sort((a, b) => b.count.compareTo(a.count));
      for (int i = 0; i < _maxLegendItems - 1; i++) {
        if (activitiesCopy[i].name.length > _maxLegendStringLength) {
          dataMap['${activitiesCopy[i].name.substring(0, _maxLegendStringLength - 5)}...'] =
              activitiesCopy[i].count.toDouble();
        } else {
          dataMap[activitiesCopy[i].name] = activitiesCopy[i].count.toDouble();
        }
        //print(activitiesCopy[i].name);
      }
      var othersCount = 0;
      for (int i = _maxLegendItems - 1; i < activitiesCopy.length; i++) {
        othersCount += activitiesCopy[i].count;
      }
      dataMap['Others'] = othersCount.toDouble();
    }

    _activitiesDataMap = dataMap;
  }

  void updateCategoriesDataMap(Tracker tracker, List<Activity> activities) {
    Map<String, double> dataMap = {};
    dataMap[tracker.categories[ActivityCategory.productive]!] = activities
        .where((a) => a.category == ActivityCategory.productive)
        .fold(0, (a, b) => a + b.count);

    dataMap[tracker.categories[ActivityCategory.necessary]!] = activities
        .where((a) => a.category == ActivityCategory.necessary)
        .fold(0, (a, b) => a + b.count);

    dataMap[tracker.categories[ActivityCategory.waste]!] = activities
        .where((a) => a.category == ActivityCategory.waste)
        .fold(0, (a, b) => a + b.count);

    _categoriesDataMap = dataMap;
  }

  bool noDataYet(List<Activity> activities) {
    for (final a in activities) {
      if (a.count > 0) {
        return false;
      }
    }
    return true;
  }

  Widget chartForCurrent(BoxConstraints constraints) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      //color: Colors.white,
      elevation: 10,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Switch(
                value: _showCategoriesChart,
                onChanged: (val) {
                  setState(() {
                    _showCategoriesChart = val;
                  });
                },
              ),
              const Text('Show results per category'),
            ],
          ),
          PieChart(
            dataMap:
                _showCategoriesChart ? _categoriesDataMap : _activitiesDataMap,
            chartRadius: constraints.maxWidth * 0.4,
            chartType: ChartType.ring,
            ringStrokeWidth: 20,
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValueBackground: false,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget chartForPreviousTrackers(BoxConstraints constraints) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Switch(
              value: _showCategoriesChart,
              onChanged: (val) {
                setState(() {
                  _showCategoriesChart = val;
                });
              },
            ),
            const Text('Show results per category'),
          ],
        ),
        PieChart(
          dataMap:
              _showCategoriesChart ? _categoriesDataMap : _activitiesDataMap,
          chartRadius: constraints.maxWidth * 0.4,
          chartType: ChartType.ring,
          ringStrokeWidth: 20,
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
            showChartValueBackground: false,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget chartAreaBuilder(
    List<Activity> activities,
    BoxConstraints constraints,
    Tracker tracker,
    TimeOfDay startTime,
  ) {
    return noDataYet(activities)
        ? SizedBox(
            height: widget.trackerId != null ? null : 250,
            child: Center(
              child: ListTile(
                leading: Icon(
                  Icons.show_chart_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
                title: Text(
                  widget.trackerId == null
                      ? 'This is where you\'ll see partial results. Monitoring starts on ${DateFormat.yMMMd('en_US').format(tracker.startDate)} at ${startTime.format(context)}.'
                      : 'No data gathered for this checker.',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: widget.trackerId == null
                    ? PageHeading(
                        pageTitle: 'Good Day!',
                        pageDescription: tracker.status == TrackerStatus.current
                            ? tracker.trackerMode ==
                                    TrackerMode.activitySampling
                                ? 'Here are the partial results of your productivity checker.'
                                : 'Here are the partial results of your mood checker.'
                            : tracker.trackerMode ==
                                    TrackerMode.activitySampling
                                ? 'Here are the final results of your productivity checker from ${DateFormat.yMMMd('en_US').format(tracker.startDate)} to ${DateFormat.yMMMd('en_US').format(tracker.endDate)}.'
                                : 'Here are the final results of your mood checker from ${DateFormat.yMMMd('en_US').format(tracker.startDate)} to ${DateFormat.yMMMd('en_US').format(tracker.endDate)}.',
                      )
                    : null,
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.trackerId == null) chartForCurrent(constraints),
              if (widget.trackerId != null)
                chartForPreviousTrackers(constraints),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    late final Tracker tracker;
    late final List<Activity> activities;
    final TimeOfDay startTime =
        ref.read(selectedDaysProvider)[0].observationStartTime!;

    if (widget.trackerId != null) {
      tracker = ref
          .watch(trackersListProvider)
          .firstWhere((element) => element.id == widget.trackerId, orElse: () {
        return Tracker(
          id: 999,
          isSameTimeForAllDays: true,
          isWithBreakTime: false,
          isNightShift: false,
          isActivitiesCategorized: true,
          trackerMode: TrackerMode.activitySampling,
          status: TrackerStatus.unfinished,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          trackerFrequency: TrackerFrequency.moderate,
        );
      });

      activities = ref.watch(resultsActivitiesProvider);
    } else {
      tracker = ref.watch(trackerProvider);
      activities = ref.watch(activitiesProvider);
    }

    updateActivitiesDataMap(activities);
    updateCategoriesDataMap(tracker, activities);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return widget.trackerId != null
            ? Container(
                color: COLOR[0],
                child: chartAreaBuilder(
                  activities,
                  constraints,
                  tracker,
                  startTime,
                ),
              )
            : Container(
                child: chartAreaBuilder(
                  activities,
                  constraints,
                  tracker,
                  startTime,
                ),
              );
      },
    );
  }
}
