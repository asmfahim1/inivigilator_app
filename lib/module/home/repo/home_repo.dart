import 'package:get/get_connect/http/src/response/response.dart';
import 'package:invigilator_app/core/utils/api_client.dart';
import 'package:invigilator_app/core/utils/app_constants.dart';
import 'package:invigilator_app/core/utils/const_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepo{
  late final ApiClient apiClient;
  late final SharedPreferences sharedPreferences;

  HomeRepo({required this.apiClient, required this.sharedPreferences});


  // final String bearerToken = 'Ez6ChKkntsIiWjjb1MCxLerwCqW4q6t1eN7fSeSM';
  // Future<FaceDetectModel> fetchEmployees() async {
  //   final url = Uri.parse(
  //       'https://grypas.inflack.xyz/grypas-api/api/v1/employee/trained'); // Replace with your API endpoint
  //   final headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer $bearerToken"
  //   };
  //   final body = jsonEncode({
  //     "type" : "",
  //     "customer_id" : 19
  //   });
  //   final response = await http.post(url, headers: headers, body: body);
  //
  //   if (kDebugMode) {
  //     print('-------- response from api : ${response.body}');
  //   }
  //
  //   if (response.statusCode == 200) {
  //     return ApiResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load employees');
  //   }
  // }


  Future<Response> getAllFaceVectors() async {
    return await apiClient.getData(AppConstants.getFaceVectors);
  }


  Future<Response> uploadPresentStudentData(dynamic apiBody) async {
    return await apiClient.putData(AppConstants.uploadPresentStudentData, apiBody);
  }


  Future<Response> getExamWiseRoomList() async {
    String examId = sharedPreferences.getString(AppConstantKey.EXAM_ID.key) ?? '';
    return await apiClient.getData("${AppConstants.getExamIdWiseRoomList}$examId");
  }

}