import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/response.dart';
import '../styling/my_consumer_stateful_widget.dart';
import '../models/observation.dart';
import '../models/tracker.dart';
import './records_page.dart';
import './set_schedule_page.dart';
import '../widgets/current_checker/input_observation.dart';
import '../widgets/records/start_new_tracker_dialog.dart';
import './current_tracker_page.dart';
import '../styling/app_theme_data.dart';
import '../services/notification_helper.dart';

class TabsPage extends ConsumerStatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  MyConsumerState<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends MyConsumerState<TabsPage>
    with WidgetsBindingObserver {
  late final LocalNotificationHelper _notificationHelper;
  late Timer _recordTimer;

  var _isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _notificationHelper = LocalNotificationHelper();
    _notificationHelper.initialize();
    WidgetsBinding.instance.addObserver(this);
    _setTimeForNextObservation();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _setTimeForNextObservation() {
    try {
      final tracker = ref.read(trackerProvider);
      tracker.updateObservationsOnLoad(ref);
      Observation nextObservation = tracker.nextObservation(ref);
      // print(
      //     'next observation time: ${nextObservation.dateTime.toIso8601String()}');

      if (tracker.isWithNextObservation(ref)) {
        //print('with next observation!');
        Timer(nextObservation.dateTime.difference(DateTime.now()), () {
          _recordTimer = Timer(
              const Duration(minutes: Observation.recordNowDuration),
              () => _missObservation(nextObservation));
          ref.read(observationsProvider.notifier).updateObservation(
                trackerId: nextObservation.trackerId,
                id: nextObservation.id,
                status: ObservationStatus.recordNow,
              );
          _startRecordObvservation(nextObservation, false);
        });
      } else if (tracker.status != TrackerStatus.finished) {
        _checkFinishTracking();
      }
      //print('Timer set for Observation id: ${nextObservation.id}');
    } catch (e) {
      //print('No next observation');
    }
  }

  void _startRecordObvservation(Observation obs, bool isForUpdate) {
    if (_isDialogOpen) {
      Navigator.of(context).pop();
    }
    showDialog(
        //barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: InputObservation(
              isForUpdate: isForUpdate,
              observation: obs,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          );
        }).then((value) {
      _isDialogOpen = false;
      if (value == null) {
        return;
      }
      if (!isForUpdate) {
        _setTimeForNextObservation();
        _recordTimer.cancel();
      } else {
        _checkFinishTracking(isFromPendingObservation: true);
      }
      if (_needToShowResponse(value)) {
        _showResponseToNegativeMood(
          responseScenario:
              DateTime.now().difference(obs.dateTime).inMinutes >= 15
                  ? ResponseScenario.notRecent
                  : ResponseScenario.recent,
        );
      }
      _showSnackBar(const Text('Self-check recorded!'));
    });

    _isDialogOpen = true;
  }

  void _showSnackBar(Widget content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(MySnackBar(context: context, child: content));
  }

  bool _needToShowResponse(dynamic val) {
    final tracker = ref.read(trackerProvider);
    if (tracker.status == TrackerStatus.current &&
        tracker.trackerMode == TrackerMode.moodSampling &&
        val == ActivityCategory.waste &&
        tracker.pendingAndCurrentObservations(ref).isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void _showResponseToNegativeMood(
      {required ResponseScenario responseScenario}) {
    _isDialogOpen = true;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: const EdgeInsets.all(0),
          content: ResponseToNegativeMood(
            responseScenario: responseScenario,
          ),
        );
      },
    ).then((_) {
      _isDialogOpen = false;
    });
  }

  void _checkFinishTracking({bool? isFromPendingObservation}) {
    final tracker = ref.read(trackerProvider);

    if (tracker.isTimeToFinishTracking(ref)) {
      _finishTracking();
    } else if (tracker.isWithPendingObservation(ref)) {
      if (isFromPendingObservation != null && isFromPendingObservation) {
        return;
      } else {
        _remindPendingObservations();
      }
    }
  }

  void _remindPendingObservations() {
    if (_isDialogOpen) {
      Navigator.of(context).pop();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: ValidationDialog(
            title: 'Almost Done!',
            description:
                'There will be no more self-checks for this Checker. To complete this, you may review the missed self-checks.',
            width: MediaQuery.of(context).size.width * 0.8,
            isForConfirmation: false,
          ),
        );
      },
    ).then((_) => _isDialogOpen = false);
    _isDialogOpen = true;
  }

  void _finishTracking() {
    ref.read(trackerProvider.notifier).finishTracking();
    if (_isDialogOpen) {
      Navigator.of(context).pop();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: ValidationDialog(
            title: 'Monitoring Finished!',
            description:
                'Done monitoring! We hope you can gain helpful insights from the results. You can also start another checker whenever you are ready.',
            width: MediaQuery.of(context).size.width * 0.8,
            isForConfirmation: false,
          ),
        );
      },
    ).then((_) => _isDialogOpen = false);
    _isDialogOpen = true;
  }

  void _missObservation(Observation obs) {
    if (_isDialogOpen) {
      Navigator.of(context).pop();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: ValidationDialog(
            title: 'Missed Self-Check',
            description:
                'You\'ve missed a self-check! No worries, you can always go back and udpate once you are available.',
            width: MediaQuery.of(context).size.width * 0.8,
            isForConfirmation: false,
          ),
        );
      },
    ).then((_) => _isDialogOpen = false);

    _isDialogOpen = true;

    ref
        .read(observationsProvider.notifier)
        .updateObservation(
          trackerId: obs.trackerId,
          id: obs.id,
          status: ObservationStatus.missed,
        )
        .then(((value) => _setTimeForNextObservation()));
  }

  void _startCreateNewTracker() async {
    final trackersCount = ref.read(trackersListProvider).length;

    if (trackersCount < Tracker.maxTrackers) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
              contentPadding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: StartNewTrackerDialog(
                isFromHomePage: false,
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: ValidationDialog(
              title: 'Max Checker Count',
              description:
                  'The maximum number of checkers has been reached. Consider deleting old checkers if you wish to start a new one.',
              isForConfirmation: false,
            ),
          );
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //print('app state = $state');
    if (state == AppLifecycleState.inactive) {
      if (ref.read(trackerProvider).isWithNextObservation(ref)) {
        _notificationHelper.setNotificationsForNextObservations(3, ref);
      }
      return;
    }
    if (state == AppLifecycleState.resumed) {
      _notificationHelper.cancelNotifications();
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  var _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: _selectedPageIndex == 0
          ? Image.asset(
              'assets/images/logo-appbar.png',
              fit: BoxFit.fitHeight,
              height: kToolbarHeight,
            )
          : const Text('All Checkers'),
      centerTitle: true,
      elevation: 1,
    );

    return Scaffold(
      floatingActionButton: _selectedPageIndex == 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                _startCreateNewTracker();
              },
              child: const Icon(Icons.add_chart_rounded),
            ),
      appBar: appBar,
      body: [
        CurrentTrackerPage(startRecordObservation: _startRecordObvservation),
        RecordsPage(
            //finishTracking: finishTracking,
            ),
      ][_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val) {
          _selectPage(val);
        },
        backgroundColor: Theme.of(context).primaryColor,
        //backgroundColor: COLOR[0],
        //backgroundColor: Colors.orange[400],
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Records',
          ),
        ],
      ),
    );
  }
}

class ResponseToNegativeMood extends StatelessWidget {
  final ResponseScenario responseScenario;
  const ResponseToNegativeMood({
    required this.responseScenario,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final response = Response.get(responseScenario);
    return ThemedFormContainer(
      width: mq.size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Column(
              children: [
                Expanded(
                  child: Icon(
                    response.iconData,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            title: Text(
              response.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Text(
            response.content,
          ),
          const SizedBox(
            height: 10,
          ),
          ThemedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }
}
