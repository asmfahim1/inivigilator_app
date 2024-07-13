import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
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
            SizedBox(
              height: Dimensions.height10 * 5.7,
              width: Dimensions.width100 * 2.4,
              child: Image.asset(appIconImage),
            ),
            TextWidget(
              'splash_text'.tr,
              style: TextStyles.title22.copyWith(color: primaryColor),
            )
          ],
        ),
      ),
    );
  }
}