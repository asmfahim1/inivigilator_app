import 'package:flutter/material.dart';
import 'package:invigilator_app/module/auth/login/view/widgets/login_form_section_widget.dart';
import '../../../../core/utils/exports.dart';
import '../../../../core/widgets/sized_box_height_20.dart';
import '../../../../core/widgets/text_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
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
                const SizedBox(
                  height: 100,
                ),
                TextWidget(
                  'Welcome to Face Detection App',
                  style: TextStyles.title20.copyWith(color: whiteColor),
                ),
                const SizedBoxHeight20(),
                const LoginFormSectionWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
