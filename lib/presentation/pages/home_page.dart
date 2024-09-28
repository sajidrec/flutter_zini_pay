import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zini_app/presentation/state_holders/home_page_controller.dart';
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
            child: GetBuilder<HomePageController>(
              builder: (homePageController) {
                return Column(
                  children: [
                    SizedBox(
                      height: Get.height / 6,
                    ),
                    homePageController.smsSyncActive
                        ? _buildCorrectCheckMark()
                        : _buildCrossCheckMark(),
                    const SizedBox(height: 10),
                    Text(
                      homePageController.smsSyncActive
                          ? "Active"
                          : "Deactivate",
                      style: const TextStyle(
                        fontSize: 36,
                        fontFamily: "Acme",
                      ),
                    ),
                    SizedBox(height: Get.height / 7),
                    _buildStartStopButton(),
                  ],
                );
              },
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
      child: GetBuilder<HomePageController>(builder: (homePageController) {
        return ElevatedButton(
          onPressed: () async {
            await homePageController.startStopSmsSync();
          },
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            homePageController.smsSyncActive ? "Stop" : "Start",
            style: const TextStyle(
              fontFamily: "Acme",
              fontSize: 24,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCorrectCheckMark() {
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

  Widget _buildCrossCheckMark() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.forwardDeactivateRed,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: AppColors.backwardDeactivateRed,
          width: 25,
        ),
      ),
      child: Icon(
        Icons.close,
        color: AppColors.elevatedButtonTextColor,
        size: 55,
      ),
    );
  }
}
