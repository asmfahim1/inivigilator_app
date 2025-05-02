import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class UnfairnessController extends GetxController {
  RxList<CheatingReport> reports = <CheatingReport>[].obs;

  @override
  void onInit() {
    super.onInit();
    addNewReport(); // start with one form
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
    // Your image picking logic (use ImagePicker package)
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      reports[index].imageFile.value = File(pickedFile.path);
    }
  }

  void submitReport() {
    final result = reports.map((report) => {
      "name": report.name.value,
      "rollNo": report.rollNo.value,
      "examName": report.examName.value,
      "imagePath": report.imageFile.value?.path ?? "",
    }).toList();

    print(result); // Use this list as needed
  }
}

class CheatingReport {
  Rxn<File> imageFile = Rxn<File>();
  RxString name = ''.obs;
  RxString rollNo = ''.obs;
  RxString examName = ''.obs;
}