import 'package:get/get_connect/http/src/response/response.dart';
import 'package:invigilator_app/core/utils/api_client.dart';
import 'package:invigilator_app/core/utils/app_constants.dart';
import 'package:invigilator_app/core/utils/const_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  late final ApiClient apiClient;
  late final SharedPreferences sharedPreferences;

  LoginRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllExams() async {
    return await apiClient.getData(AppConstants.getAllExams);
  }

  Future<Response> login(Map<String, dynamic> loginBody) async {
    return await apiClient.postData(AppConstants.loginUrl, loginBody);
  }

  // saveUserToken(String token, bool registrationDone) async {
  //   apiClient.token = token;
  //   apiClient.updateHeader(token);
  //
  //   await sharedPreferences.setString(AppConstantKey.TOKEN.key, token);
  //   await sharedPreferences.setBool(AppConstantKey.REGISTRATION.key, registrationDone);
  // }

  saveUserToken(String token) async {
    apiClient.token = token;

    await sharedPreferences.setString(AppConstantKey.TOKEN.key, token);
  }

  // Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
  //   String userInfoString = jsonEncode(userInfo);
  //   await sharedPreferences.setString('loginBody', userInfoString);
  // }
  //
  // Future<Map<String, dynamic>?> getUserInfo() async {
  //   String? loginBodyString = sharedPreferences.getString('loginBody');
  //   if (loginBodyString != null) {
  //     Map<String, dynamic> loginBody = jsonDecode(loginBodyString);
  //     return loginBody;
  //   }
  //   return null;
  // }

  // saveUserToken(String token, User user) async {
  //   apiClient.token = token;
  //   apiClient.updateHeader(token);
  //
  //   //await PrefHelper.setString(AppConstantKey.TOKEN.key, token);
  //   await sharedPreferences.setString(AppConstantKey.TOKEN.key, token);
  //
  //   String userJson = json.encode(user.toJson());
  //   await sharedPreferences.setString(AppConstantKey.USER_INFO.key, userJson);
  // }

  // static Future<User?> getUser() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userJson = prefs.getString(AppConstantKey.USER_INFO.key);
  //   if (userJson != null) {
  //     Map<String, dynamic> userMap = json.decode(userJson);
  //     return User.fromJson(userMap);
  //   }
  //   return null;
  // }

  bool userLoggedIn() {
    // Check if the key exists and the value is true
    return sharedPreferences.getBool(AppConstantKey.REGISTRATION.key) ?? false;
  }

  bool userLoggedOut() {
    // Check if the key exists and the value is true
    return sharedPreferences.containsKey(AppConstantKey.REGISTRATION.key);
  }

  Future<String> getUserToken() async {
    //PrefHelper.getString(AppConstantKey.TOKEN.key);

    return sharedPreferences.getString(AppConstantKey.TOKEN.key) ?? "None";
  }

  bool clearSharedData() {
    // PrefHelper.logout();
    sharedPreferences.remove(AppConstantKey.TOKEN.key);
    sharedPreferences.remove(AppConstantKey.REGISTRATION.key);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }
}
