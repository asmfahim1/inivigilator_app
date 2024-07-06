import 'package:invigilator_app/core/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepo{
  late final ApiClient apiClient;
  late final SharedPreferences sharedPreferences;

  HomeRepo({required this.apiClient, required this.sharedPreferences});



}