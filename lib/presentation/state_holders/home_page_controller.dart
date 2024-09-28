import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zini_app/presentation/utility/constants.dart';

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

    update();
  }
}
