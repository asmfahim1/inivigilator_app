import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:invigilator_app/core/utils/api_client.dart';
import 'package:invigilator_app/module/home/model/face_detector_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestRepo{
  late final ApiClient apiClient;
  late final SharedPreferences sharedPreferences;

  TestRepo({required this.apiClient, required this.sharedPreferences});

  final String bearerToken =
      'Ez6ChKkntsIiWjjb1MCxLerwCqW4q6t1eN7fSeSM';
  Future<ApiResponse> fetchEmployees() async {
    final url = Uri.parse(
        'https://grypas.inflack.xyz/grypas-api/api/v1/employee/trained'); // Replace with your API endpoint
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $bearerToken"
    };
    final body = jsonEncode({
      "type" : "",
      "customer_id" : 19
    });
    final response = await http.post(url, headers: headers, body: body);

    if (kDebugMode) {
      print('-------- response from api : ${response.body}');
    }

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load employees');
    }
  }







}