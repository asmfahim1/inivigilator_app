import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/api_client.dart';
import 'package:invigilator_app/core/utils/app_constants.dart';
import 'package:invigilator_app/module/auth/login/controller/login_controller.dart';
import 'package:invigilator_app/module/auth/login/repo/login_repo.dart';
import 'package:invigilator_app/module/home/controller/home_controller.dart';
import 'package:invigilator_app/module/home/controller/test_controller.dart';
import 'package:invigilator_app/module/home/controller/unfairness_controller.dart';
import 'package:invigilator_app/module/home/repo/home_repo.dart';
import 'package:invigilator_app/module/home/repo/test_repo.dart';
import 'package:invigilator_app/module/home/repo/unfairness_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  //shared preference
  Get.lazyPut(() => sharedPreferences, fenix: true);

  // Get.put<NetworkController>(NetworkController(), permanent: true);

  // api client
  Get.lazyPut(
      () => ApiClient(
          appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()),
      fenix: true);

  ///Repo
  Get.lazyPut(
      () => LoginRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  Get.lazyPut(
      () => HomeRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  Get.lazyPut(
      () => TestRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  Get.lazyPut(
      () => UnfairnessRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      fenix: true);

  ///Controller
  //Auth
  Get.lazyPut(() => LoginController(loginRepo: Get.find<LoginRepo>()),
      fenix: true);


  Get.lazyPut(() => HomeController(homeRepo: Get.find<HomeRepo>()),
      fenix: true);


  Get.lazyPut(() => TestController(testRepo: Get.find<TestRepo>()),
      fenix: true);


  Get.lazyPut(() => UnfairnessController(unfairnessRepo: Get.find<UnfairnessRepo>()),
      fenix: true);
}
