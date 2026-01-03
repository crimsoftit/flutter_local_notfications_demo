import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notfications_demo/notifications/local_notifications.dart';
import 'package:flutter_local_notfications_demo/screens/another_page.dart';

class CAlertsScreen extends StatefulWidget {
  const CAlertsScreen({super.key});

  @override
  State<CAlertsScreen> createState() => _CAlertsScreenState();
}

class _CAlertsScreenState extends State<CAlertsScreen> {
  @override
  void initState() {
    listenToNotificationEvents();
    super.initState();
  }

  /// -- listen to notification events --
  listenToNotificationEvents() {
    if (kDebugMode) {
      print('listening to notification events...');
    }
    LocalNotifications.onNotificationClicked.stream.listen((event) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AnotherPage(
              payload: event,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('flutter local notifications demo')),
      body: Column(
        children: [
          // -- trigger basic notification --
          ElevatedButton.icon(
            icon: Icon(
              Icons.notifications,
            ),
            label: Text(
              'basic notification',
            ),
            onPressed: () {
              LocalNotifications.displaySimpleAlert(
                title: "simple notification title",
                body: "this is a simple notification body",
                payload: "payload",
              );
            },
          ),

          // -- trigger periodic notification --
          ElevatedButton.icon(
            icon: Icon(
              Icons.timer,
            ),
            label: Text(
              'periodic notification',
            ),
            onPressed: () {
              LocalNotifications.displayPeriodicNotification(
                title: "periodic notification title",
                body: "this is a periodic notification body",
                payload: "payload",
              );
            },
          ),

          // -- trigger scheduled notification --
          ElevatedButton.icon(
            icon: Icon(
              Icons.timer,
            ),
            label: Text(
              'scheduled notification',
            ),
            onPressed: () {
              LocalNotifications.triggerScheduledNotification(
                title: "scheduled notification title",
                body: "this is a scheduled notification body",
                payload: "payload",
              );
            },
          ),

          /// -- trigger close/cancel of a specific periodic notification --
          TextButton.icon(
            icon: Icon(Icons.delete_outline),
            label: Text(
              'close periodic notification',
            ),
            onPressed: () {
              LocalNotifications.closeNotification(1);
            },
          ),

          /// -- trigger close/cancel of all periodic notifications --
          TextButton.icon(
            icon: Icon(Icons.delete_forever),
            label: Text(
              'close all notifications',
            ),
            onPressed: () {
              LocalNotifications.closeAllNotifications();
            },
          ),
        ],
      ),
    );
  }
}
