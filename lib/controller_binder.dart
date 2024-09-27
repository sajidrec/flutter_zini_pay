import 'package:get/get.dart';
import 'package:zini_app/presentation/state_holders/login_page_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginPageController());
  }
}
