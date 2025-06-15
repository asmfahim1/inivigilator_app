import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:invigilator_app/core/utils/dialogue_utils.dart';
import 'package:invigilator_app/module/home/repo/unfairness_repo.dart';
import 'package:path_provider/path_provider.dart';


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

  RxString selectedFrontImagePath = ''.obs;
  RxString frontFileName = ''.obs;
  Future<void> pickImage(int index) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        Get.back(); // If you’re using a bottom sheet/dialog
        DialogUtils.showNoImageTakenWarning();
        return;
      }

      final File imageFile = File(pickedFile.path);
      String fileName = 'ProxyImage_${pickedFile.path.split('/').last}';

      Get.back();
      DialogUtils.showLoading(title: 'uploading'.tr);

      final File? compressedFile = await adaptiveCompressImage(imageFile.path);

      if (compressedFile == null) {
        DialogUtils.closeLoading();
        DialogUtils.showErrorDialog(description: 'Compression failed', btnName: 'try_again_btn'.tr);
        return;
      }

      // final response = await unfairnessRepo!.uploadFileWithDio(imageFile, fileName);
      final response = await unfairnessRepo!.uploadFileWithDio(compressedFile, fileName);

      DialogUtils.closeLoading();

      if (response["status"] == 201) {
        // Update the report's file and uploaded path
        // reports[index].imageFile.value = imageFile;
        reports[index].imageFile.value = imageFile;
        reports[index].uploadedImagePathList.value = response["imagePath"];
      } else {
        DialogUtils.showSnackBar(
          'upload_failed'.tr,
          response["error"],
        );
      }
    } catch (e) {
      DialogUtils.closeLoading();
      DialogUtils.showSnackBar(
        'upload_failed'.tr,
        e.toString(),
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
          "proxy_img_id": report.imageFile.value ?? "",
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

Future<File?> adaptiveCompressImage(String path, {int targetWidth = 600, int jpegQuality = 60}) async {
  try {
    final originalBytes = await File(path).readAsBytes();
    final originalImage = img.decodeImage(originalBytes);

    if (originalImage == null) {
      // print("Invalid image data");
      return null;
    }

    // Resize while maintaining aspect ratio
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: targetWidth,
    );

    // Compress directly at fixed quality
    final compressedBytes = img.encodeJpg(resizedImage, quality: jpegQuality);

    // Save compressed image to temp directory
    final tempDir = await getTemporaryDirectory();
    final compressedFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await compressedFile.writeAsBytes(compressedBytes);

    // print("Compressed file size: ${compressedBytes.length} bytes (${compressedBytes.length / 1024} KB)");
    return compressedFile;
  } catch (e) {
    print("Compression error: $e");
    return null;
  }
}


class CheatingReport {
  Rxn<String> uploadedImagePathList = Rxn<String>();
  Rxn<File> imageFile = Rxn<File>();
  // RxString uploadedImagePath = ''.obs;
  RxString examName = ''.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
}