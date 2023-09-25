// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// class ApiClient {
//   http.Client? httClient;
//
//   ApiClient({this.httClient}) {
//     httClient ??= http.Client();
//   }
//
//   Future<http.Response> getRequest(String url) async {
//     final completeUrl = _buildUrl(url);
//     log('Checking for Get API start & end point $completeUrl');
//     final headers = await _getHeaders();
//     return httClient!.get(Uri.parse(completeUrl), headers: headers);
//   }
//
//   Future<http.Response> postRequest(
//       String url,
//       Map<String, dynamic> body, {
//         Duration? timeout,
//         bool checkAccessValidity = true,
//       }) async {
//     final completeUrl = _buildUrl(url);
//     log('Checking for Post API start & end point $completeUrl');
//     final headers = await _getHeaders();
//     final encodedBody = json.encode(body);
//     return httClient!
//         .post(Uri.parse(completeUrl), headers: headers, body: encodedBody);
//   }
//
//   Future<http.Response> putRequest(
//       String url,
//       Map<String, dynamic> body, {
//         Duration? timeout,
//       }) async {
//     final completeUrl = _buildUrl(url);
//     log('Checking for Put API start & end point $completeUrl');
//     final headers = await _getHeaders();
//     final encodedBody = json.encode(body);
//     return httClient!
//         .put(Uri.parse(completeUrl), headers: headers, body: encodedBody);
//   }
//
//   Future<Map<String, String>> _getHeaders() async {
//     final accessToken = await AccessTokenProvider().getToken();
//     final headers = <String, String>{
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     };
//     if (accessToken!.isNotEmpty) {
//       headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $accessToken'});
//     }
//     return headers;
//   }
//
//   Future<http.StreamedResponse> multiPartRequest(
//       String url,
//       Map<String, String> body, {
//         Duration? timeout,
//         bool checkAccessValidity = true,
//       }) async {
//     final completeUrl = _buildUrl(url);
//
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse(completeUrl),
//     );
//
//     final accessToken = await AccessTokenProvider().getToken();
//
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//     };
//     if (accessToken!.isNotEmpty) {
//       request.headers.addAll(headers);
//     }
//     request.fields.addAll(body);
//     final response = await request.send();
//     return response;
//   }
//
//   Future<http.StreamedResponse> multiPartRequestWithFile(
//       String url,
//       Map<String, String> body,
//       String? filepath,
//       String? fileKeyName, {
//         bool hasFile = true,
//       }) async {
//     final headers = await _getHeaders();
//     final completeUrl = _buildUrl(url);
//
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse(completeUrl),
//     );
//     request.fields.addAll(body);
//     if (hasFile) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           fileKeyName!,
//           filepath!,
//         ),
//       );
//     }
//     log('Checking for Post API start & end point ${json.encode(body)}');
//     request.headers.addAll(headers);
//     final response = await request.send();
//     return response;
//   }
//
//   String _buildUrl(String partialUrl) {
//     final baseUrl = Urls.baseUrl;
//     return baseUrl + partialUrl;
//   }
// }
