import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styling/app_theme_data.dart';
import './pages/home_page.dart';
import './services/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  LocalNotificationHelper notificationHelper = LocalNotificationHelper();
  notificationHelper.initialize();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String? payload;
  if (notificationAppLaunchDetails != null) {
    if (notificationAppLaunchDetails.notificationResponse != null) {
      payload = notificationAppLaunchDetails.notificationResponse!.payload;
    }
  }

  runApp(MyApp(
    payload: payload,
  ));
}

class MyApp extends ConsumerWidget {
  MyApp({this.payload, Key? key}) : super(key: key);
  String? payload;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: MaterialApp(
          title: 'WorkSampler',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.purple,
            fontFamily: 'Quicksand',
            appBarTheme: AppBarTheme(
              //backgroundColor: Colors.orange,
              backgroundColor: COLOR[0],
              titleTextStyle: const TextStyle(
                color: Colors.purple,
                fontSize: 20,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
              foregroundColor: Colors.purple,
              elevation: 0,
            ),
          ),
          home: HomePage(payload: payload)),
    );
  }
}
