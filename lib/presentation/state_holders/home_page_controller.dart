import 'dart:convert';

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

  Future<void> startStopSmsSync() async {
    _smsSyncActive = !_smsSyncActive;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.isSmsServiceActiveKey, _smsSyncActive);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (_smsSyncActive) {
      int lastShownMessageTime =
          sharedPreferences.getInt(Constants.lastShownSmsKey) ??
              DateTime.now().millisecondsSinceEpoch;

      if (sharedPreferences.getInt(Constants.lastShownSmsKey) == null) {
        sharedPreferences.setInt(
            Constants.lastShownSmsKey, lastShownMessageTime);
      }

      final dio = Dio();
      final allSms = await dio.get(Urls.allSmsUrl);
      List smsList = allSms.data["data"];

      List<SmsModel> listFilteredMessage = smsList
          .map((element) =>
              SmsModel.fromJson(element)) // Convert JSON to SmsModel
          .where((sms) =>
              DateTime.parse(sms.time ?? "").millisecondsSinceEpoch >
              lastShownMessageTime) // Correct the condition
          .toList();

      for (int i = 0; i < listFilteredMessage.length; i++) {
        if (DateTime.parse(listFilteredMessage[i].time ?? "")
                .millisecondsSinceEpoch >
            lastShownMessageTime) {
          await sharedPreferences.setInt(
            Constants.lastShownSmsKey,
            DateTime.parse(listFilteredMessage[i].time ?? "")
                .millisecondsSinceEpoch,
          );
        }

        await NotificationService.showNotification(
          id: i + 1,
          title: listFilteredMessage[i].from ?? "",
          body: listFilteredMessage[i].message ?? "",
          fln: flutterLocalNotificationsPlugin,
        );
      }

      print(
          "sajid ${DateTime.parse("2024-09-28T21:54:55.703504").millisecondsSinceEpoch}");
      print("sajid ${sharedPreferences.getInt(Constants.lastShownSmsKey)}");
    }

    update();
  }
}
