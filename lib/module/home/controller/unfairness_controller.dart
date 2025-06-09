import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invigilator_app/core/utils/dialogue_utils.dart';
import 'package:invigilator_app/module/home/repo/unfairness_repo.dart';


class UnfairnessController extends GetxController {
  UnfairnessRepo? unfairnessRepo;
  UnfairnessController({this.unfairnessRepo});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxList<CheatingReport> reports = <CheatingReport>[].obs;

  @override
  void onInit() {
    super.onInit();
    addNewReport();
  }

  void addNewReport() {
    reports.add(CheatingReport());
  }

  void removeReport(int index) {
    if (reports.length > 1) {
      reports.removeAt(index);
    }
  }

  void pickImage(int index) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        Get.back(); // If you’re using a bottom sheet/dialog
        DialogUtils.showNoImageTakenWarning();
        return;
      }

      final File imageFile = File(pickedFile.path);
      String fileName = 'ProxyImage_${pickedFile.path.split('/').last}';

      DialogUtils.showLoading(title: 'uploading'.tr);

      final response = await unfairnessRepo!.uploadFileWithDio(imageFile, fileName);

      DialogUtils.closeLoading();

      if (response["status"] == 201) {
        // Update the report's file and uploaded path
        // reports[index].imageFile.value = imageFile;
        reports[index].imageFile.value = response["imagePath"];
      } else {
        DialogUtils.showErrorDialog(
          description: 'upload_failed'.tr,
          btnName: 'try_again_btn'.tr,
        );
      }
    } catch (e) {
      DialogUtils.closeLoading();
      DialogUtils.showErrorDialog(
        btnName: 'try_again_btn'.tr,
        description: "$e",
      );
    }
  }

  // RxBool isProxyDataUploaded = false.obs;
  Future<void> submitReport() async {
    DialogUtils.showLoading(title: 'submitting'.tr);
    if (!formKey.currentState!.validate()) {
      Get.snackbar('Validation Error', 'Please fill all required fields');
      return;
    }

    // Optional: Validate image presence
    final hasAllImages = reports.every((report) => report.imageFile.value != null);
    if (!hasAllImages) {
      Get.snackbar('Image Required', 'Please upload an image for every form');
      return;
    }

    //isProxyDataUploaded(true);
    try {
      final apiBody = {
        "proxy_attendace": reports.map((report) => {
          "id": report.rollNoController.text,
          "proxy_img_id": report.imageFile.value?.path ?? "",
        }).toList(),
      };

      final response = await unfairnessRepo!.uploadProxyStudentData(apiBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Clear all existing reports
        reports.clear();

        // ✅ Add a new empty form
        addNewReport();

        Get.snackbar('Success', 'Proxy data uploaded and form reset.');
      } else {
        throw Exception('Failed to upload proxy data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload proxy data: $e');
    } finally {
      DialogUtils.closeLoading();
    }
  }
}

class CheatingReport {
  Rxn<File> imageFile = Rxn<File>();
  RxString uploadedImagePath = ''.obs;
  RxString examName = ''.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
}