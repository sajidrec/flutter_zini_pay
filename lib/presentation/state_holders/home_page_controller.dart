import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zini_app/data/models/sms_model.dart';
import 'package:zini_app/data/utility/urls.dart';
import 'package:zini_app/presentation/utility/constants.dart';
import 'package:zini_app/services/notification_service.dart';

class HomePageController extends GetxController {
  bool _smsSyncActive = false;

  set setSmsSyncActive(bool value) {
    _smsSyncActive = value;
    update();
  }

  bool get smsSyncActive => _smsSyncActive;

  Timer? _timer;

  Future<void> startStopSmsSync() async {
    _smsSyncActive = !_smsSyncActive;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.isSmsServiceActiveKey, _smsSyncActive);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (_smsSyncActive) {
      _timer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) async => _getSms(
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        ),
      );
    } else {
      _timer?.cancel();
    }

    update();
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
}
