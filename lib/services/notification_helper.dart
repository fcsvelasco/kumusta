import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../models/tracker.dart';

class LocalNotificationHelper {
  LocalNotificationHelper();

  final _localNotificationHelper = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const settings = InitializationSettings(
      android:
          AndroidInitializationSettings('@drawable/ic_stat_icon_transparent'),
    );

    await _localNotificationHelper.initialize(
      settings,
      onDidReceiveNotificationResponse: ((details) =>
          LocalNotificationHelper.onSelectNotification(details)),
      // onDidReceiveBackgroundNotificationResponse: ((details) =>
      //     LocalNotificationHelper.onSelectNotification(details)),
    );
  }

  static void onSelectNotification(NotificationResponse notificationResponse) {
    //print('notificationResponse payload: ${notificationResponse.payload}');
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute<void>(builder: (context) => const TabsPage()));
  }

  Future<void> _setScheduledNotification({
    required int id,
    required String title,
    required String body,
    //required Duration duration,
    required DateTime dateTime,
    required String payload,
  }) async {
    final notificationDetails = await _notificationDetails();
    await _localNotificationHelper.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        dateTime,
        tz.local,
      ),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payload,
    );

    //print('Notification scheduled on ${dateTime.toIso8601String()}');
  }

  Future<void> setNotificationsForNextObservations(
      int count, WidgetRef ref) async {
    try {
      final observations =
          ref.read(trackerProvider).nextObservations(ref, count);
      for (int i = 0; i < observations.length; i++) {
        await _setScheduledNotification(
            id: i,
            title: 'Kumusta?',
            body: 'Time for self-check!',
            dateTime: observations[i].dateTime,
            payload: 'tabs_page');
      }

      DateTime lastNotification =
          observations[observations.length - 1].dateTime;

      await _setScheduledNotification(
        id: count,
        title: 'Kumusta?',
        body:
            'You\'ve been missing self-checks. No worries, you can always go back once you are available.',
        dateTime: DateTime(
          lastNotification.year,
          lastNotification.month,
          lastNotification.day,
          lastNotification.hour,
          lastNotification.minute + 10,
        ),
        payload: 'tabs_page',
      );

      for (int i = 0; i < 5; i++) {
        //set notifications for next 5 days if user is not opening the app.
        await _setScheduledNotification(
          id: count,
          title: 'Kumusta?',
          body:
              'You\'ve been missing self-checks. You can update them anytime, but it\'s best to do it without much delay.',
          dateTime: DateTime(
            lastNotification.year,
            lastNotification.month,
            lastNotification.day + i + 1,
            lastNotification.hour,
            lastNotification.minute,
          ),
          payload: 'tabs_page',
        );
      }
    } catch (e) {
      //print('setNotificationsForNextObservations() error : $e');
    }
  }

  Future<void> setNotificationsForNextDays() async {
    try {} catch (e) {
      //print('setNotificationsForNextDays() error : $e');
    }
  }

  Future<void> cancelNotifications() async {
    try {
      await FlutterLocalNotificationsPlugin().cancelAll();
      //print('Notifications cancelled');
    } catch (e) {
      //print('cancelAllNotifications() error: $e');
    }
  }

  Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
      ),
    );
  }
}
