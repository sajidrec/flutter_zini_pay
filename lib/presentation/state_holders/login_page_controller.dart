import 'package:get/get.dart';

class LoginPageController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<void> signIn() async {
    _inProgress = true;
    update();

    _inProgress = false;
    update();
  }
}
