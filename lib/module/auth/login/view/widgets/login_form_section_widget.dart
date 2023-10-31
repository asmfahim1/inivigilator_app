import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../../core/utils/validator.dart';
import '../../../../../core/widgets/common_button.dart';
import '../../../../../core/widgets/common_text_field_widget.dart';
import '../../../../../core/widgets/sized_box_height_20.dart';
import '../../../../../core/widgets/text_widget.dart';
import '../../controller/login_controller.dart';

class LoginFormSectionWidget extends StatefulWidget {
  const LoginFormSectionWidget({Key? key}) : super(key: key);

  @override
  State<LoginFormSectionWidget> createState() => _LoginFormSectionWidgetState();
}

class _LoginFormSectionWidgetState extends State<LoginFormSectionWidget> {
  final login = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Container(
        height: size.height / 2,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: whiteColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBoxHeight20(),
            _textFields(),
            const SizedBox(
              height: 15,
            ),
            const SizedBoxHeight20(),
            _loginButton(),
            /*const SizedBoxHeight20(),
            GestureDetector(
              onTap: () {
                //go to registration page
                Get.toNamed(AppRoutes.registrationPage);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget('Don\'t have an account?',
                      style: TextStyles.title16.copyWith(color: whiteColor)),
                  TextWidget(
                    'Sign Up',
                    style: TextStyles.title16.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _textFields() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: size.height / 14,
          width: size.width,
          padding:
          const EdgeInsets.only(left: 10, right: 10),
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DropdownButton(
            underline: const SizedBox(),
            // to remove the default underline of DropdownButton
            iconSize: 30.0,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            items: <String>['Bank exam', 'BDC exam', 'Biman exam', 'PSC exam']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              login.setSelectedValue(newValue!);
            },
            hint: Obx(() => TextWidget(
              login.examType.value,
              style: TextStyles.title16,
            )),
            isExpanded: true,
            // to make the dropdown button span the full width of the container
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBoxHeight20(),
        CommonTextField(
          hintText: 'Email',
          validator: Validator().nullFieldValidate,
          controller: login.email,
          onFieldSubmitted: (v) {
            FocusScope.of(context).requestFocus(_passwordFocus);
          },
        ),
        const SizedBoxHeight20(),
        Obx(() {
          return CommonTextField(
            validator: Validator().nullFieldValidate,
            hintText: 'Password',
            focusNode: _passwordFocus,
            controller: login.password,
            obSecure: !login.passwordVisible,
            onFieldSubmitted: (v) {
              //login method will call
            },
            suffixIcon: IconButton(
              color: blackColor,
              icon: login.passwordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                login.passwordVisible = !login.passwordVisible;
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _loginButton() {
    Size size = MediaQuery.of(context).size;
    return CommonButton(
      btnHeight: size.height / 20,
      width: size.width / 1.6,
      buttonColor: blueColor,
      buttonTitle: 'Login',
      onTap: () {
        //login method will call
        Get.toNamed(AppRoutes.homeScreen);
      },
    );
  }
}
