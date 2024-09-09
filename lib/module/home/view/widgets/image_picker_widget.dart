import 'dart:io';
import 'package:flutter/material.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import '../../../../core/utils/colors.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final void Function()? onTap;
  const ImagePickerWidget({
    Key? key,
    this.imageFile,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: Dimensions.height100 * 1.75,
        width: Dimensions.width100 * 1.55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: greyTextColor),
        ),
        child: SizedBox(
          height: Dimensions.height10 * 4.8,
          width: Dimensions.width10 * 4.8,
          child: imageFile != null
              ? Image.file(
                  imageFile!,
                  width: Dimensions.width100 * 2,
                  height: Dimensions.height100 * 2,
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.camera_alt_outlined,
                  size: Dimensions.iconSize25 * 2,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}