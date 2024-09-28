import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zini_app/presentation/utility/app_colors.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.cursorColor,
        ),
      ),
    ));
  }
}
