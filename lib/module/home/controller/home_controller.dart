import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:invigilator_app/core/utils/dialogue_utils.dart';
import 'package:invigilator_app/core/utils/styles.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import 'package:invigilator_app/module/home/model/exam_hall_list_model.dart';
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
    getExamWiseRoom();  
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


  RxBool isRoomLoaded = false.obs;
  RxList<Room> examRooms = <Room>[].obs;
  RxList<Exam> allExams = <Exam>[].obs;
  Rx<Exam?> todayExam = Rx<Exam?>(null);

  Future<void> getExamWiseRoom() async {
    isRoomLoaded(true);
    try {
      final response = await homeRepo!.getExamWiseRoomList();
      if (response.statusCode == 200) {
        final data = response.body;

        List<Exam> exams = (data as List)
            .map((e) => Exam.fromJson(e))
            .toList();

        // Filter one exam for today
        DateTime today = DateTime.now();
        Exam? examToday = exams.firstWhereOrNull((exam) {
          final examDate = DateTime.tryParse(exam.examDate ?? '');
          if (examDate == null) return false;
          return examDate.year == today.year &&
              examDate.month == today.month &&
              examDate.day == today.day;
        });

        todayExam.value = examToday;

        // Load rooms from that exam only
        examRooms.value = examToday?.rooms ?? [];
      } else {
        print('Failed to fetch exam rooms');
      }
    } catch (e) {
      print('Error fetching exam rooms: $e');
    } finally {
      isRoomLoaded(false);
    }
  }


  List<Exam> filterTodayExams(List<Exam> exams) {
    DateTime today = DateTime.now();
    return exams.where((exam) {
      final examDate = DateTime.tryParse(exam.examDate ?? '');
      if (examDate == null) return false;
      return examDate.year == today.year &&
          examDate.month == today.month &&
          examDate.day == today.day;
    }).toList();
  }

  List<Room> getTodayRooms(List<Exam> exams) {
    return filterTodayExams(exams).expand((exam) => exam.rooms ?? <Room>[]).toList();
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


  RxBool isAttendanceUploaded = false.obs;
  Future<void> uploadPresentStudentData() async {
    isAttendanceUploaded(true);
    try {
      final List<int> ids = attendedStudents.map((student) => student["id"] as int).toList();
      final Map<String, dynamic> body = {
        'ids': ids,
      };

      final response = await homeRepo!.uploadPresentStudentData(body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        await dbHelper.clearAttendanceTable();
        attendedStudents.clear();
        await fetchPresentStudent();

        Get.snackbar('Success', 'Attendance data uploaded and cleared.');
      } else {
        throw Exception('Failed to upload attendance data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload attendance data: $e');
    } finally {
      isAttendanceUploaded(false);
    }
  }
}