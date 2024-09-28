import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zini_app/presentation/utility/constants.dart';
import 'package:zini_app/services/notification_service.dart';

class HomePageController extends GetxController {
  bool _smsSyncActive = false;

  set setSmsSyncActive(bool value) {
    _smsSyncActive = value;
    update();
  }

  bool get smsSyncActive => _smsSyncActive;

  Future<void> startStopSmsSync({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) async {
    _smsSyncActive = !_smsSyncActive;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.isSmsServiceActiveKey, _smsSyncActive);

    if (_smsSyncActive) {
      await NotificationService.showNotification(
        title: "Zini",
        body: "App is running",
        fln: flutterLocalNotificationsPlugin,
      );
    }

    update();
  }
}
