import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:invigilator_app/core/utils/app_routes.dart';
import 'package:invigilator_app/core/utils/const_key.dart';
import 'package:invigilator_app/core/utils/network_connectivity_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstantKey.TOKEN.key) ?? '';
    _mainHeaders = _createHeaders(token);
  }

  Map<String, String> _createHeaders(String token) {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    return headers;
  }

  void updateHeader(String token) {
    _mainHeaders = _createHeaders(token);
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    if (!await _checkInternetOrReturnError()) {
      return const Response(statusCode: 0, statusText: "No internet connection");
    }
    try {
      Response response = await get(Uri.encodeFull(uri), headers: headers ?? _mainHeaders);
      return _handleResponseStatus(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }


  Future<Response> postData(String uri, dynamic body) async {
    if (!await _checkInternetOrReturnError()) {
      return const Response(statusCode: 0, statusText: "No internet connection");
    }

    try {
      Response response = await post(uri, jsonEncode(body), headers: _mainHeaders);
      return _handleResponseStatus(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }


  Future<Response> putData(String uri, dynamic body) async {
    if (!await _checkInternetOrReturnError()) {
      return const Response(statusCode: 0, statusText: "No internet connection! \nPlease check your internet first.");
    }

    try {
      Response response = await put(uri, jsonEncode(body), headers: _mainHeaders);
      return _handleResponseStatus(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Map<String, dynamic>> uploadFileWithDio(
      String uri, File file, String fileName) async {
    Map<String, dynamic> map = {};

    if (!await _checkInternetOrReturnError()) {
      throw 'No internet connection';
    }

    try {

      String completeUrl = '$baseUrl$uri';

      final request = dio.Dio();
      final formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          //contentType: MediaType('application', 'pdf'),
        ),
      });

      final response = await request.postUri(
        Uri.parse(
          completeUrl,
        ),
        data: formData,
        options: dio.Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'multipart/form-data; charset=UTF-8',
            HttpHeaders.contentLengthHeader: formData.length,
          },
        ),
      );
      _handleResponseStatus(Response(
        statusCode: response.statusCode,
        statusText: response.statusMessage,
      ));

      map = response.data;
      return map;
    } on dio.DioException {
      throw 'Something Went Wrong';
    } catch (error) {
      throw 'Something Went Wrong';
    }
  }

  // Method to handle response status
  dynamic _handleResponseStatus(Response response) {
    switch (response.statusCode) {
      case 401:
        clearSharedData();
        Get.offAllNamed(AppRoutes.loginScreen);
        break;
      default:
        return response;
    }
  }


  Future<bool> _checkInternetOrReturnError() async {
    bool hasInternet = await NetworkConnection.instance.hasInternetConnection();
    if (!hasInternet) {
      Get.snackbar("No Internet", "Please check your internet connection.");
    }
    return hasInternet;
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstantKey.TOKEN.key);
    token = '';
    updateHeader('');
    return true;
  }
}
