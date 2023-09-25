import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class CommonTextField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final String? labelText;
  final double? labelFontSize;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool? minimizeBottomPadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? margin;
  final FocusNode? focusNode;
  final bool? autofocus;
  final bool? enabled;
  final bool? autovalidate;
  final bool? readOnly;
  final bool? isRequired;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final GestureTapCallback? onTap;
  final Key? textFieldKey;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? borderRadius;
  final bool? isFilled;
  final Color fillColor;
  final bool? obSecure;
  final double? topPadding;
  final double? leftContentPadding;
  final double? hintSize;
  final List<TextInputFormatter>? inputFormatters;
  final Color? focusBorderColor;
  final Color? enableBorderColor;
  final double? labelLeftPadding;
  final double? labelBottomPadding;

  const CommonTextField({
    super.key,
    this.labelLeftPadding = 0,
    this.labelBottomPadding = 0,
    this.labelFontSize = 14,
    this.focusBorderColor = const Color(0xffD6DCFF),
    this.minimizeBottomPadding = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.validator,
    this.prefix,
    this.errorText,
    this.onChanged,
    this.textInputAction,
    this.autovalidate = false,
    this.controller,
    this.onFieldSubmitted,
    this.focusNode,
    this.hintSize = 14,
    this.isRequired = false,
    this.autofocus = false,
    this.labelText,
    this.fillColor = silverGrayColor,
    this.isFilled = true,
    this.hintText,
    this.minLines,
    this.prefixIcon,
    this.obSecure = false,
    this.suffixIcon,
    this.borderRadius = 4,
    this.onTap,
    this.margin = EdgeInsets.zero,
    this.keyboardType,
    this.leftContentPadding = 15,
    this.contentPadding =
    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    this.maxLines = 1,
    this.textFieldKey,
    this.topPadding = 25,
    this.inputFormatters,
    this.enableBorderColor = const Color(0xffFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        children: [
          if (labelText != null)
            Padding(
              padding: EdgeInsets.only(
                left: labelLeftPadding!,
                bottom: labelBottomPadding!,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      labelText ?? '',
                      style: TextStyles.regular14
                          .copyWith(fontSize: labelFontSize),
                    ),
                  ),
                  if (isRequired!)
                    Text(
                      ' *',
                      style: TextStyles.regular14
                          .copyWith(color: const Color(0xffFF5B71)),
                    )
                ],
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            inputFormatters: inputFormatters,
            obscureText: obSecure!,
            key: textFieldKey,
            onTap: onTap,
            readOnly: readOnly!,
            enabled: enabled,
            maxLength: maxLength,
            minLines: minLines,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            autofocus: autofocus!,
            focusNode: focusNode,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              filled: isFilled,
              fillColor: fillColor,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefix: prefix,
              border: InputBorder.none,
              hintStyle: TextStyles.regular14.copyWith(
                fontSize: hintSize,
              ),
              errorStyle: const TextStyle(color: Colors.red),
              focusColor: whiteColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: whiteColor),
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
              contentPadding:
              EdgeInsets.fromLTRB(leftContentPadding!, topPadding!, 40, 0),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: whiteColor),
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: whiteColor),
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(borderRadius!),
              ),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}