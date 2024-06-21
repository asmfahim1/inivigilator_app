import 'dart:io';
import 'package:flutter/material.dart';
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
        height: 170,
        width: 155,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: strokeColor),
        ),
        child: SizedBox(
          height: 48,
          width: 48,
          child: imageFile != null
              ? Image.file(
                  imageFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : const Icon(
                  Icons.camera_alt_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}