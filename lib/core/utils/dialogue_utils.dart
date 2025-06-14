import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';

class DialogUtils {
  static void showLoading({required String title}) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(title),
              ],
            ),
          ),
        );
      },
    );
  }

  static void closeLoading() {
    Navigator.of(Get.context!).pop();
  }

  static void showErrorDialog({
    String title = "Oops Error",
    String description = "Something went wrong ",
    String btnName = "Close",
  }) {
    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.padding15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                title,
                style: TextStyles.title16,
              ),
              SizedBox(height: Dimensions.height10),
              TextWidget(
                description,
                style: TextStyles.regular14,
              ),
              FilledButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: Text(btnName),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void showSnackBar(String messageTitle, String messageBody,
      {int seconds = 2, Color bgColor = redColor}) {
    Get.snackbar(
      messageTitle,
      messageBody,
      icon: const Icon(Icons.person, color: Colors.white),
      borderWidth: 1.5,
      borderColor: Colors.black54,
      colorText: Colors.white,
      backgroundColor: bgColor,
      duration: Duration(seconds: seconds),
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showNoImageTakenWarning(
      {int seconds = 1, Color bgColor = redColor}) {
    Get.snackbar(
      'warning'.tr,
      'no_image_selected'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: redColor,
      colorText: whiteColor,
      duration: const Duration(seconds: 2),
    );
  }
}
