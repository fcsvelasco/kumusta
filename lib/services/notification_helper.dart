import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

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

  Future<void> setScheduledNotification({
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
