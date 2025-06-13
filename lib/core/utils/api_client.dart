import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:invigilator_app/core/utils/app_routes.dart';
import 'package:invigilator_app/core/utils/const_key.dart';
import 'package:invigilator_app/core/utils/network_connectivity_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

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
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = _createHeaders(token);
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    if (!await _checkInternetOrReturnError()) {
      return Response(statusCode: 0, statusText: 'no_internet'.tr);
    }

    final fullUrl = baseUrl! + uri;
    log('GET Request: $fullUrl');
    log('Headers: ${headers ?? _mainHeaders}');

    try {
      final response = await get(uri, headers: headers ?? _mainHeaders);
      _logResponse('GET', response);
      return _handleResponseStatus(response);
    } catch (e, stackTrace) {
      _logError('GET', fullUrl, e);
      return Response(statusCode: 1, statusText: "${e.toString()} $stackTrace");
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    if (!await _checkInternetOrReturnError()) {
      return Response(statusCode: 0, statusText: 'no_internet'.tr);
    }

    final fullUrl = baseUrl! + uri;
    log('POST Request: $fullUrl');
    log('Request Body: ${jsonEncode(body)}');
    log('Headers: $_mainHeaders');

    try {
      final response = await post(uri, jsonEncode(body), headers: _mainHeaders);
      _logResponse('POST', response);
      return _handleResponseStatus(response);
    } catch (e, stackTrace) {
      _logError('POST', fullUrl, e);
      return Response(statusCode: 1, statusText: "${e.toString()} $stackTrace");
    }
  }

  Future<Response> putData(String uri, dynamic body) async {
    if (!await _checkInternetOrReturnError()) {
      return Response(statusCode: 0, statusText: 'no_internet'.tr);
    }

    final fullUrl = baseUrl! + uri;
    log('PUT Request: $fullUrl');
    log('Request Body: ${jsonEncode(body)}');
    log('Headers: $_mainHeaders');

    try {
      final response = await put(uri, jsonEncode(body), headers: _mainHeaders);
      _logResponse('PUT', response);
      return _handleResponseStatus(response);
    } catch (e, stackTrace) {
      _logError('PUT', fullUrl, e);
      return Response(statusCode: 1, statusText: "${e.toString()} $stackTrace");
    }
  }

  Future<Response> deleteData(String uri, {dynamic body, Map<String, String>? headers}) async {
    if (!await _checkInternetOrReturnError()) {
      return Response(statusCode: 0, statusText: 'no_internet'.tr);
    }

    final fullUrl = baseUrl! + uri;
    log('DELETE Request: $fullUrl');
    log('Request Body: ${jsonEncode(body)}');
    log('Headers: ${headers ?? _mainHeaders}');

    try {
      final response = await delete(
        uri,
        query: body,
        headers: headers ?? _mainHeaders,
      );
      _logResponse('DELETE', response);
      return _handleResponseStatus(response);
    } catch (e, stackTrace) {
      _logError('DELETE', fullUrl, e);
      return Response(statusCode: 1, statusText: "$e $stackTrace");
    }
  }

  Future<Map<String, dynamic>> uploadFile(
      String uri,
      File file,
      String fileName,
      ) async {
    if (!await _checkInternetOrReturnError()) {
      throw Exception('no_internet'.tr);
    }

    final fullUrl = baseUrl! + uri;
    try {
      final formData = FormData({
        'image': MultipartFile(file, filename: fileName),
      });

      log('UPLOAD Request: $fullUrl');
      log('Uploading file: ${file.path}');
      log('Headers: ${"Authorization : Bearer $token"}');

      final response = await post(
          uri,
          formData,
          headers: {
            'Authorization': 'Bearer $token',
          }
      );
      _logResponse('UPLOAD', response);

      _handleResponseStatus(response);
      return response.body;
    } catch (e, stackTrace) {
      _logError('UPLOAD', fullUrl, e);
      log('Stack trace: $stackTrace');
      throw Exception('File upload failed: ${e.toString()}');
    }
  }

  Response _handleResponseStatus(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      // Success, allow the response to be returned
        return response;

      case 400:
      // Handle bad request
        log('Bad request: ${response.body}');
        throw Exception('Bad request');

      case 401:
        clearSharedData();
        Get.offAllNamed(AppRoutes.loginScreen);
        throw Exception('Unauthorized');

      case 403:
        log('Forbidden access');
        return response;
    // throw Exception('Forbidden access');

      case 404:
        log('Resource not found');
        return response;
    // throw Exception('Resource not found');

      case 500:
        log('Server error: ${response.body}');
        return response;
    // throw Exception('Internal server error');

      default:
        log('Unhandled status code: ${response.statusCode}');
        return response;
    // throw Exception('Unexpected status code: ${response.statusCode}');
    }
  }


  void _logResponse(String method, Response response) {
    log('$method Response (${response.statusCode}):');
    log('Headers: ${response.headers}');
    log('Body: ${response.bodyString}');
  }

  void _logError(String method, String url, dynamic error) {
    log('$method Error: $url');
    log('Error: ${error.toString()}');
    if (error is dio.DioException) {
      log('Dio Error: ${error.response?.data}');
    }
  }

  Future<bool> _checkInternetOrReturnError() async {
    final hasInternet = await NetworkConnection.instance.hasInternetConnection();
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
