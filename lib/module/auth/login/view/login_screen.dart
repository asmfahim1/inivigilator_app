import 'package:flutter/material.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/module/auth/login/controller/login_controller.dart';
import 'package:invigilator_app/module/auth/login/view/widgets/login_form_section_widget.dart';
import 'package:get/get.dart';
import '../../../../core/utils/exports.dart';
import '../../../../core/widgets/sized_box_height_20.dart';
import '../../../../core/widgets/text_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Dimensions.screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(loginBackImagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Dimensions.height100,
                ),
                TextWidget(
                  'welcome'.tr,
                  style: TextStyles.title16.copyWith(color: whiteColor),
                ),
                const SizedBoxHeight20(),
                LoginFormSectionWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
