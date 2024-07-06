import 'package:flutter/material.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';

import '../utils/colors.dart';
import '../utils/styles.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.buttonTitle,
    this.onPressed,
    this.height = 45,
    this.width = 120,
    this.fontSize = 16,
    this.borderRadius = 6,
    this.buttonTextColor,
    this.fontWeight = FontWeight.w500,
    this.buttonColor,
  }) : super(key: key);

  final String buttonTitle;
  final double height;
  final VoidCallback? onPressed;
  final double width;
  final double borderRadius;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    Color btnColor = buttonColor ?? primaryColor;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: strokeColor, width: 1.2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: btnColor,
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: height,
        child: Center(
          child: TextWidget(
            buttonTitle,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyles.title16.copyWith(
              color: buttonTextColor ?? whiteColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
