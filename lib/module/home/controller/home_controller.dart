import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/db_helper.dart';
import 'package:invigilator_app/core/utils/string_resource.dart';
import 'package:invigilator_app/module/home/repo/home_repo.dart';

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
        var faceVectorString = (student['face_vector']).join(',');
        student['face_vector'] = faceVectorString; // Convert list to comma-separated string
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

  // Future<void> fetchStudentsFromApi() async {
  //   final url = 'YOUR_API_ENDPOINT'; // Replace with your API endpoint
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       List<dynamic> apiData = json.decode(response.body);
  //       List<StudentModel> studentsList = apiData.map((json) => StudentModel.fromJson(json)).toList();
  //       await insertStudents(studentsList);
  //     } else {
  //       print('Failed to load students from API');
  //     }
  //   } catch (e) {
  //     print('Error fetching students from API: $e');
  //   }
  // }

}