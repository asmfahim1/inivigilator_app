import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:invigilator_app/core/utils/dialogue_utils.dart';
import 'package:invigilator_app/core/utils/string_resource.dart';
import 'package:invigilator_app/core/utils/styles.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import 'package:invigilator_app/module/home/model/face_detector_model.dart';
import 'package:invigilator_app/module/home/repo/home_repo.dart';

class HomeController extends GetxController{
  HomeRepo? homeRepo;
  HomeController({this.homeRepo});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dbHelper.init();
    getProfileInformation();
  }


  Future<void> getProfileInformation() async {
    try {
      final response = await homeRepo!.getAllFaceVectors();
      if (response.statusCode == 200) {
        final data = response.body;
        print('Profile Information: $data');
      } else {
        print('Failed to fetch profile information');
      }
    } catch (e) {
      print('Error fetching profile information: $e');
    }
  }

  var students = <Map<String, dynamic>>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper();


  Future<void> fetchStudents() async {
    try {
      final data = await dbHelper.getStudents();
      students.value = data;
      print('Students list : ${students.length}');


    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  RxBool isStudentFetched = false.obs;
  Future<void> insertStudents() async {
    isStudentFetched(true);
    try {

      final response = await homeRepo!.getAllFaceVectors();

      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        if (await dbHelper.hasStudents()) {
          await dbHelper.clearDatabase();
        }

        faceVectorModel.value = FaceDetectModel.fromJson(response.body);
        for (int i = 0; i < faceVectorModel.value.data!.length; i++) {
          var students = faceVectorModel.value.data![i];
          for (int j = 0; j < students.studentsFaceVector!.length; j++) {
            final faceVectors = students.studentsFaceVector![j];

            // Parse the face vector string as a list of doubles
            List<double> faceEmbedding = List<double>.from(jsonDecode(faceVectors.faceVector!).map((x) => x as double));

            // Insert into the database, encode the list of doubles as a JSON array
            Map<String, dynamic> row = {
              DatabaseHelper.studentId: students.id,
              DatabaseHelper.student_name: "${students.name}_${students.id}_$j",
              DatabaseHelper.columnEmbedding: jsonEncode(faceEmbedding),  // Store as a JSON array of doubles
            };

            final id = await dbHelper.insert(row);
            print('Data Inserted in row : $id');
          }
        }
      }

      fetchStudents();

      isStudentFetched(false);

    } catch (error) {
      isStudentFetched(false);
      if (kDebugMode) {
        print('=======Something went wrong====$error');
      }
    }
  }

  RxBool isAttendedFound = false.obs;
  RxInt attendanceCount = 0.obs;
  var attendedStudents = <Map<String, dynamic>>[].obs;
  Future<void> fetchPresentStudent() async {
    isAttendedFound(true);
    try {
      final data = await dbHelper.getAllAttendedStudent();
      attendedStudents.value = data;
    } catch (e) {
      print("Error fetching students: $e");
    } finally {
      isAttendedFound(false);
    }
  }


  Rx<FaceDetectModel> faceVectorModel = FaceDetectModel().obs;
  Future<void> loadStudentFaceData() async {
    try {
      DialogUtils.showLoading(title: 'Fetching data...');
      final response = await homeRepo!.getAllFaceVectors();

      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        if (await dbHelper.hasStudents()) {
          await dbHelper.clearDatabase();
        }

        faceVectorModel.value = FaceDetectModel.fromJson(response.body);
        for (int i = 0; i < faceVectorModel.value.data!.length; i++) {
          var students = faceVectorModel.value.data![i];
          for (int j = 0; j < students.studentsFaceVector!.length; j++) {
            final faceVectors = students.studentsFaceVector![j];

            // Parse the face vector string as a list of doubles
            List<double> faceEmbedding = List<double>.from(jsonDecode(faceVectors.faceVector!).map((x) => x as double));

            // Insert into the database, encode the list of doubles as a JSON array
            Map<String, dynamic> row = {
              DatabaseHelper.studentId: students.id,
              DatabaseHelper.student_name: "${students.name}_${students.id}_$j",
              DatabaseHelper.columnEmbedding: jsonEncode(faceEmbedding),  // Store as a JSON array of doubles
            };

            final id = await dbHelper.insert(row);
            print('Data Inserted in row : $id');
          }
        }

        DialogUtils.closeLoading();

      } else {
        DialogUtils.closeLoading();
        throw Exception('Failed to load students');
      }
    } catch (e) {
      DialogUtils.closeLoading();
      if (kDebugMode) {
        print('Error loading students data: $e');
      }
      throw Exception('Failed to load students $e');
    }
  }

  //for exit the app
  Future<bool?> showWarningContext(BuildContext context) async => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: TextWidget(
        'Exit',
        style: TextStyles.title20,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextWidget('Do you want to exit the app?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: TextWidget(
            'Cancel',
            style: TextStyles.regular16.copyWith(color: redColor),
          ),
        ),
        TextButton(
          onPressed: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          child: TextWidget(
            'Yes',
            style: TextStyles.regular16.copyWith(color: primaryColor),
          ),
        ),
      ],
    ),
  );
}