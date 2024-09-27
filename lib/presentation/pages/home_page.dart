import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zini_app/presentation/utility/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width / 8),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 6,
                ),
                _buildCheckMark(),
                const SizedBox(height: 10),
                const Text(
                  "Active",
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: "Acme",
                  ),
                ),
                SizedBox(height: Get.height / 7),
                _buildStartStopButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartStopButton() {
    return SizedBox(
      width: double.maxFinite,
      height: max(Get.height / 14, 50),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: const Text(
          "Stop",
          style: TextStyle(
            fontFamily: "Acme",
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckMark() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.forwardActiveGreen,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.backwardActiveGreen,
          width: 25,
        ),
      ),
      child: Icon(
        Icons.check_sharp,
        color: AppColors.elevatedButtonTextColor,
        size: 55,
      ),
    );
  }
}
