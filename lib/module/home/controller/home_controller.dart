import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:invigilator_app/core/utils/string_resource.dart';
import 'package:invigilator_app/module/home/home_repo.dart';

class HomeController extends GetxController{
  HomeRepo? homeRepo;
  HomeController({this.homeRepo});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dbHelper.init();
  }

  var students = <Map<String, dynamic>>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper();


  Future<void> fetchStudents() async {
    try {
      final data = await dbHelper.getStudents();
      students.value = data;
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  RxBool isStudentFetched = false.obs;
  Future<void> insertStudents() async {
    isStudentFetched(true);
    try {
      if (await dbHelper.hasStudents()) {
        await dbHelper.clearDatabase();
      }
      for (var student in studentsList) {
        student['face_vector'] = student['face_vector'].toString();
        await dbHelper.insertStudent(student);
      }
      fetchStudents();

    } catch (error) {
      if (kDebugMode) {
        print('=======Something went wrong====$error');
      }
    } finally {
      isStudentFetched(false);
    }
  }
}