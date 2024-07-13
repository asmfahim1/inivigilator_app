import 'package:flutter/material.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';

class UploadedPicturesWidget extends StatelessWidget {
  const UploadedPicturesWidget(
      this.iconPath, {
        Key? key,
        this.height = 18,
        this.width = 18,
        this.color,
      }) : super(key: key);
  final String iconPath;
  final double height;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radius20 * 2.5),
      child: Icon(
        Icons.person,
        size: Dimensions.iconSize30,
      ),
    );
  }
}
