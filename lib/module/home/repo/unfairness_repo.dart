import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:invigilator_app/core/utils/app_constants.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnfairnessRepo{
  late final ApiClient apiClient;
  late final SharedPreferences sharedPreferences;

  UnfairnessRepo({required this.apiClient, required this.sharedPreferences});


  Future<Response> uploadProxyStudentData(dynamic apiBody) async {
    return await apiClient.putData(AppConstants.uploadPresentStudentData, apiBody);
  }

  Future<Map<String, dynamic>> uploadFileWithDio(File file, String fileName) async {
    return await apiClient.uploadFile(AppConstants.fileUpload, file, fileName);
  }

}