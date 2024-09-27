import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:zini_app/presentation/pages/home_page.dart';
import 'package:zini_app/presentation/state_holders/login_page_controller.dart';
import 'package:zini_app/presentation/utility/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _apiTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/login_page_background.png",
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 7),
                  child: _buildLoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SizedBox(
      width: double.maxFinite,
      child: GetBuilder<LoginPageController>(
        builder: (loginPageController) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  controller: _emailTEController,
                  enabled: !loginPageController.inProgress,
                  decoration: loginPageController.inProgress
                      ? InputDecoration(
                          filled: true,
                          fillColor: AppColors.disabledBorderBgColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                              style: BorderStyle.none,
                              width: 0,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Api Key",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  controller: _apiTEController,
                  enabled: !loginPageController.inProgress,
                  decoration: loginPageController.inProgress
                      ? InputDecoration(
                          filled: true,
                          fillColor: AppColors.disabledBorderBgColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: const BorderSide(
                              style: BorderStyle.none,
                              width: 0,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      await loginPageController.signIn(
                        email: _emailTEController.text.trim(),
                        apiKey: _apiTEController.text,
                      );

                      await Fluttertoast.showToast(
                        msg: loginPageController.loginResponseModel.message ??
                            "",
                      );

                      if (loginPageController.loginResponseModel.success ??
                          false) {
                        Get.offAll(() => const HomePage());
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 18,
                          color: loginPageController.inProgress
                              ? AppColors.elevatedButtonPressedTextColor
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _apiTEController.dispose();
  }
}
