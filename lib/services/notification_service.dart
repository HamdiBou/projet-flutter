import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static Future<void> showNotification({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Main channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> scheduleNotification({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    tz.initializeTimeZones();
    final String currentTimeZone = 'America/Los_Angeles';
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Channel',
          channelDescription: 'Scheduled channel for notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }
}