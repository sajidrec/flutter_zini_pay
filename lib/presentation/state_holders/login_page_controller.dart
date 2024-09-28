import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zini_app/data/models/login_response_model.dart';
import 'package:zini_app/data/utility/urls.dart';
import 'package:zini_app/presentation/utility/constants.dart';

class LoginPageController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  LoginResponseModel _loginResponseModel = LoginResponseModel(
    success: false,
    message: "Invalid email or API key",
  );

  LoginResponseModel get loginResponseModel => _loginResponseModel;

  Future<void> signIn({
    required String email,
    required String apiKey,
  }) async {
    _inProgress = true;
    update();

    final dio = Dio();

    try {
      final res = await dio.post(
        Urls.loginUrl,
        data: {
          "email": email,
          "apiKey": apiKey,
        },
      );
      _loginResponseModel = LoginResponseModel.fromJson(res.data);
      if (_loginResponseModel.success ?? false) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setBool(
          Constants.isLoggedInKey,
          true,
        );
      }
    } catch (e) {}

    _inProgress = false;
    update();
  }
}
