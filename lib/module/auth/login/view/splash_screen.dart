import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/widgets/exports.dart';

import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.toNamed(AppRoutes.getStartedScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 14,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Image.asset(appIconImage),
            ),
            TextWidget(
              'Invigilator DEMO APP',
              style: TextStyles.title32.copyWith(color: primaryColor),
            )
          ],
        ),
      ),
    );
  }
}