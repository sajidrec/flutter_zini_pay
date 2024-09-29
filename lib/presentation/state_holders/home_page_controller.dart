import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zini_app/data/models/sms_model.dart';
import 'package:zini_app/data/utility/urls.dart';
import 'package:zini_app/presentation/utility/constants.dart';
import 'package:zini_app/services/notification_service.dart';

Future<void> startServe(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await NotificationService.initialize(flutterLocalNotificationsPlugin);
  await NotificationService.showNotification(
    id: 9999987,
    title: "ZINI APP",
    body: "Running",
    fln: flutterLocalNotificationsPlugin,
    persistence: true,
  );

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(
    const Duration(seconds: 5),
    (timer) async => _getSms(
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    ),
  );
}

Future<void> _getSms({
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  final dio = Dio();
  final allSms = await dio.get(Urls.allSmsUrl);
  List smsList = allSms.data["data"];

  List<String> listOfShownNotificationId =
      sharedPreferences.getStringList(Constants.listOfNotificationShownId) ??
          [];

  for (int i = 0; i < smsList.length; i++) {
    SmsModel smsModel = SmsModel.fromJson(smsList[i]);
    if (!listOfShownNotificationId.contains(smsModel.id)) {
      listOfShownNotificationId.add(smsModel.id ?? "");
      await NotificationService.showNotification(
        id: i + 1,
        title: smsModel.from ?? "",
        body: smsModel.message ?? "",
        fln: flutterLocalNotificationsPlugin,
      );
    }
  }

  await sharedPreferences.setStringList(
      Constants.listOfNotificationShownId, listOfShownNotificationId);
}

class HomePageController extends GetxController {
  bool _smsSyncActive = false;

  set setSmsSyncActive(bool value) {
    _smsSyncActive = value;
    update();
  }

  bool get smsSyncActive => _smsSyncActive;

  Future<void> initializeBackgroundService() async {
    if (!_smsSyncActive) {
      return;
    }
    final service = FlutterBackgroundService();
    await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: startServe, // This is the background service entry point
        isForegroundMode: true,
        autoStart: true,
      ),
    );
    await service.startService();
  }

  Future<void> startStopSmsSync() async {
    _smsSyncActive = !_smsSyncActive;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.isSmsServiceActiveKey, _smsSyncActive);

    if (_smsSyncActive) {
      final service = FlutterBackgroundService();
      await service.configure(
        iosConfiguration: IosConfiguration(),
        androidConfiguration: AndroidConfiguration(
          onStart: startServe, // This is the background service entry point
          isForegroundMode: true,
          autoStart: true,
        ),
      );

      bool isRunning = await service.isRunning();
      if (!isRunning) {
        await initializeBackgroundService();
      }
    } else {
      final service = FlutterBackgroundService();
      bool isRunning = await service.isRunning();
      if (isRunning) {
        service.invoke("stopService");
      } else {}
    }

    update();
  }
}
