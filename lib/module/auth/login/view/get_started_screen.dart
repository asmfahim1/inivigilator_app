import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/widgets/exports.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/exports.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _topSectionWidget(context),
          _bottomSectionWidget(context),
        ],
      ),
    );
  }

  Widget _topSectionWidget(BuildContext context) {
    return Container(
      height: Dimensions.heightScreenHalf,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(loginBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _bottomSectionWidget(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.loginScreen);
        },
        child: Container(
          color: iconPrimaryColor,
          child: Column(
            children: [
              Container(
                height: Dimensions.height100 * 3.33,
                padding: allPadding20,
                child: Column(
                  children: [
                    TextWidget(
                      'welcome_text_title'.tr,
                      style: TextStyles.title20.copyWith(color: whiteColor),
                    ),
                    const SizedBoxHeight20(),
                    TextWidget(
                      'welcome_text_description'.tr,
                      style: TextStyles.regular14.copyWith(color: whiteColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: Dimensions.screenWidth,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: whiteColor,
                        width: 1.1,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: TextWidget(
                    'next_btn'.tr,
                    style: TextStyles.regular18.copyWith(color: whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}