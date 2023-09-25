import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(loginBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _bottomSectionWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                height: size.height / 2.4,
                padding: allPadding20,
                child: Column(
                  children: [
                    TextWidget(
                      'Welcome to our platform',
                      style: TextStyles.title20.copyWith(color: whiteColor),
                    ),
                    const SizedBoxHeight20(),
                    TextWidget(
                      'Face detection applications use AI algorithms, ML, statistical analysis and image processing to find human faces within larger images and distinguish them from nonface objects such as landscapes, buildings and other human body parts.',
                      style: TextStyles.regular14.copyWith(color: whiteColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: size.width,
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
                    'Next',
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