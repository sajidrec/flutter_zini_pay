import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zini_app/controller_binder.dart';
import 'package:zini_app/presentation/pages/home_page.dart';
import 'package:zini_app/presentation/pages/loading_page.dart';
import 'package:zini_app/presentation/pages/login_page.dart';
import 'package:zini_app/presentation/utility/app_colors.dart';
import 'package:zini_app/presentation/utility/constants.dart';

class ZiniApp extends StatefulWidget {
  const ZiniApp({super.key});

  @override
  State<ZiniApp> createState() => _ZiniAppState();
}

class _ZiniAppState extends State<ZiniApp> {
  Future<void> _moveToNextPage() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool(Constants.isLoggedInKey) ?? false) {
      Get.offAll(() => const HomePage());
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback(
      (timeStamp) async => await _moveToNextPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinder(),
      theme: _buildThemeData(),
      debugShowCheckedModeBanner: false,
      home: const LoadingPage(),
    );
  }

  ThemeData _buildThemeData() => ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: "Montserrat",
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.cursorColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.elevatedButtonBgColor,
            ),
            foregroundColor:
                WidgetStatePropertyAll(AppColors.elevatedButtonTextColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
          ),
        ),
      );
}
