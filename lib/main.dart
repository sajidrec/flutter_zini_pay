import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zini_app/app.dart';
import 'package:zini_app/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const ZiniApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );

  await service.startService();
}

// @pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await NotificationService.initialize(flutterLocalNotificationsPlugin);

  await NotificationService.showNotification(
    id: 0,
    title: "ZINI",
    body: "App is running",
    fln: flutterLocalNotificationsPlugin,
    persistence: true,
  );

  // bring to foreground
  // Timer.periodic(const Duration(seconds: 5), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //
  //       flutterLocalNotificationsPlugin.show(
  //         999999,
  //         'ZINI APP',
  //         'Running',
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             "notificationChannelId",
  //             'MY FOREGROUND SERVICE',
  //             icon: 'ic_bg_service_small',
  //             ongoing: true,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // });
}
