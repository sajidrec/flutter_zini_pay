import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zini_app/controller_binder.dart';
import 'package:zini_app/presentation/pages/home_page.dart';
import 'package:zini_app/presentation/pages/login_page.dart';
import 'package:zini_app/presentation/utility/app_colors.dart';

class ZiniApp extends StatelessWidget {
  const ZiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinder(),
      theme: _buildThemeData(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
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
