import 'package:get/get.dart';

class LoginPageController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<void> signIn() async {
    _inProgress = true;
    update();

    await Future.delayed(const Duration(seconds: 2));

    _inProgress = false;
    update();
  }
}
