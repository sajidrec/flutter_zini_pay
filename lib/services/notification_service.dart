import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future initialize(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');

    var iosInitialize = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin fln,
    bool persistence = false,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '2',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: false,
      ongoing: persistence,
      enableVibration: true,
    );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());
    await fln.show(id, title, body, not);
  }
}
