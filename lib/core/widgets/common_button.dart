import 'package:flutter/material.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.buttonTitle,
    this.onTap,
    this.height = 45,
    this.width = 120,
    this.fontSize = 16,
    this.borderRadius = 4,
    this.buttonTextColor,
    this.fontWeight = FontWeight.w500,
    this.buttonColor,
    this.leadingIcon,
    this.trailingIcon, required btnHeight,
  }) : super(key: key);

  final String buttonTitle;
  final double height;
  final GestureTapCallback? onTap;
  final double width;
  final double borderRadius;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? trailingIcon;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) leadingIcon!,
              const SizedBox(
                height: 10,
              ),
              Center(
                child: TextWidget(
                  buttonTitle,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyles.regular14.copyWith(
                    color: buttonTextColor ?? whiteColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (trailingIcon != null) trailingIcon!,
            ],
          ),
        ),
      ),
    );
  }
}