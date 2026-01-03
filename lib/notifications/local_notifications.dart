import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final onNotificationClicked = BehaviorSubject<String>();

  /// -- initialize the local notifications plugin. app_icon needs to be added as a drawable resource to the android head project --
  static Future initLocalNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    final LinuxInitializationSettings linuxInitSettings =
        LinuxInitializationSettings(defaultActionName: 'open notification');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitializationSettings,
      linux: linuxInitSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// -- display a simple/basic notification --
  static Future displaySimpleAlert({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channelId',
          'channelName',
          channelDescription: 'simple notification',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// -- display periodic notification at regular intervals --
  static Future displayPeriodicNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channel2_Id',
          'channel2_Name',
          channelDescription: 'simple notification',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: payload,
    );
  }

  /// -- trigger a scheduled local notification --
  static Future triggerScheduledNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel 3',
          'channelName',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  /// -- cancel/close a specific channel notification --
  static Future closeNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// -- cancel/close all notifications --
  static Future closeAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// -- what ought to happen when a notification is clicked --
  static void onNotificationTap(NotificationResponse alertResponse) {
    onNotificationClicked.add(alertResponse.payload!);
  }
}
