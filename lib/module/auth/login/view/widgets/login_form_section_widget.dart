import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/validator.dart';
import 'package:invigilator_app/module/auth/login/view/widgets/exam_list_dropdown_widget.dart';
import '../../../../../core/widgets/common_button.dart';
import '../../../../../core/widgets/common_text_field_widget.dart';
import '../../../../../core/widgets/sized_box_height_20.dart';
import '../../controller/login_controller.dart';

class LoginFormSectionWidget extends StatelessWidget {
  LoginFormSectionWidget({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  final LoginController login = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return Form(
        key: _formKey,
        child: Container(
          width: Dimensions.screenWidth,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.padding15, vertical: Dimensions.padding20 * 1.5),
          decoration: BoxDecoration(
            color: whiteColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(Dimensions.radius20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ExamDropdown(),
              const SizedBoxHeight20(),
              CommonTextField(
                hintText: 'email_hint'.tr,
                validator: Validator().nullFieldValidate,
                controller: controller.email,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
              ),

              const SizedBoxHeight20(),

              CommonTextField(
                validator: Validator().nullFieldValidate,
                hintText: 'password_hint'.tr,
                focusNode: _passwordFocus,
                controller: controller.password,
                obSecure: controller.passwordVisible,
                onFieldSubmitted: (v) {
                  // Get.toNamed(AppRoutes.homeScreen);
                  if (_formKey.currentState!.validate()) {
                    login.loginMethod();
                  }
                },
                suffixIcon: IconButton(
                  color: blackColor,
                  icon: controller.passwordVisible
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    controller.passwordVisible = !controller.passwordVisible;
                  },
                ),
              ),
              SizedBox(
                height: Dimensions.height15 * 2,
              ),
              CommonButton(
                width: Dimensions.screenWidth,
                buttonColor: blueColor,
                buttonTitle: 'login'.tr,
                onPressed: () {
                  // Get.toNamed(AppRoutes.homeScreen);
                  if (_formKey.currentState!.validate()) {
                    login.loginMethod();
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
