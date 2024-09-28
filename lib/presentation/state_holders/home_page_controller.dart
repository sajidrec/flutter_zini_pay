import 'package:get/get.dart';

class HomePageController extends GetxController {
  bool _smsSyncActive = false;

  bool get smsSyncActive => _smsSyncActive;

  Future<void> startStopSmsSync() async {
    _smsSyncActive = !_smsSyncActive;

    update();
  }
}
