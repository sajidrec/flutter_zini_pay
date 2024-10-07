import 'dart:async';
import 'dart:isolate';
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

import '../../main.dart';

Future<void> startServe(ServiceInstance service) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await NotificationService.initialize(flutterLocalNotificationsPlugin);

  await NotificationService.showNotification(
    id: 9999987,
    title: "ZINI PAY",
    body: "Running",
    fln: flutterLocalNotificationsPlugin,
    persistence: true,
  );

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  _getSms();
}

Future<void> _getSms() async {
  Timer.periodic(
    const Duration(seconds: 5),
    (timer) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      final dio = Dio();
      final allSms = await dio.get(Urls.allSmsUrl);
      List smsList = allSms.data["data"];

      List<String> listOfShownNotificationId = sharedPreferences
              .getStringList(Constants.listOfNotificationShownId) ??
          [];

      for (int i = 0; i < smsList.length; i++) {
        SmsModel smsModel = SmsModel.fromJson(smsList[i]);
        if (!listOfShownNotificationId.contains(smsModel.id)) {
          listOfShownNotificationId.add(smsModel.id ?? "");

          // Send message to the main isolate for SMS handling
          final SendPort? sendPort = IsolateNameServer.lookupPortByName(isolateName);

          if (sendPort != null) {
            sendPort.send({
              'phoneNumber': smsModel.from,
              'message': smsModel.message,
            });
          }

          // await const MethodChannel("com.example.zini_app/sms")
          //     .invokeMethod('sendSms', {
          //   'phoneNumber': smsModel.from,
          //   'message': smsModel.message,
          // });
        }
      }

      // shown
      await sharedPreferences.setStringList(
        Constants.listOfNotificationShownId,
        listOfShownNotificationId,
      );
    },
  );
}

class HomePageController extends GetxController {
  bool _smsSyncActive = false;

  set setSmsSyncActive(bool value) {
    _smsSyncActive = value;
    update();
  }

  bool get smsSyncActive => _smsSyncActive;

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
      if (!isRunning) {}
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
