import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonIconWidget extends StatelessWidget {
  const CommonIconWidget(
      this.iconPath, {
        Key? key,
        this.height = 18,
        this.onTap,
        this.width = 18,
        this.color,
      }) : super(key: key);

  final String iconPath;
  final double height;
  final double width;
  final Color? color;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}