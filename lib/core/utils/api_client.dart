import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:invigilator_app/core/utils/const_key.dart';
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
    _mainHeaders = {
      'Context-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Context-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response =
          await get(Uri.encodeFull(uri), headers: headers ?? _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      Response response =
          await post(uri, jsonEncode(body), headers: _mainHeaders);

      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String uri, dynamic body) async {
    try {
      Response response =
          await put(uri, jsonEncode(body), headers: _mainHeaders);
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Map<String, dynamic>> uploadFileWithDio(
      String uri, File file, String fileName) async {
    Map<String, dynamic> map = {};
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
      map = response.data;

      return map;
    } on dio.DioException catch (error) {

      throw 'Something Went Wrong';

    } catch (error) {

      throw 'Something Went Wrong';
    }
  }
}
