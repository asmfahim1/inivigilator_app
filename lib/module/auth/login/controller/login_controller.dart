import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/app_routes.dart';
import 'package:invigilator_app/core/utils/dialogue_utils.dart';
import 'package:invigilator_app/module/auth/login/model/all_exams_model.dart';
import 'package:invigilator_app/module/auth/login/model/login_response_model.dart';
import 'package:invigilator_app/module/auth/login/repo/login_repo.dart';

class LoginController extends GetxController {
  LoginRepo? loginRepo;
  LoginController({this.loginRepo});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final RxBool _passwordVisible = true.obs;

  set passwordVisible(bool value) {
    _passwordVisible.value = value;
    update();
  }

  bool get passwordVisible => _passwordVisible.value;

  RxString examType = 'exams'.tr.obs;
  RxInt examId = 0.obs;

  void setSelectedValue(String examName) {
    final exam = examList.firstWhere((element) => element.name! == examName);
    examType.value = exam.name!;
    examId.value = exam.id!;

    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAllExams();
  }

  RxBool isExamListLoaded = false.obs;
  // Change the RxList type to match your model
  RxList<ExamDatum> examList = <ExamDatum>[].obs;

  Future<void> getAllExams() async {
    try {
      isExamListLoaded.value = true;
      Response response = await loginRepo!.getAllExams();

      if (response.statusCode == 200 && response.body != null) {
        // Use the correct parsing method
        ExamListModel examListModel = examListModelFromJson(response.bodyString!);
        examList.value = examListModel.data ?? [];
      } else {
        examList.clear();
      }
    } catch (error) {
      DialogUtils.showErrorDialog(description: "$error");
      examList.clear();
    } finally {
      isExamListLoaded.value = false;
    }
    update();
  }

  Future<void> loginMethod() async {
    try {
      LoginResponseModel responseModel;
      DialogUtils.showLoading(title: 'please_wait'.tr);

      final Map<String, dynamic> map = <String, dynamic>{};
      map['email'] = email.text.trim();
      map['password'] = password.text.trim();
      map['exam_id'] = examId.value;

      Response response = await loginRepo!.login(map);

      if (kDebugMode) {
        print(
            'Response and maps : ${response.statusCode} =====${response.body}=========$map');
      }

      closeLoading();

      if (response.statusCode == 200) {
        responseModel = LoginResponseModel.fromJson(response.body);

        if (responseModel.data == null) {
          DialogUtils.showErrorDialog(
            title: 'warning'.tr,
            description: responseModel.message ?? 'no_data'.tr,
          );
        } else {
          await loginRepo!.saveUserToken(responseModel.token.toString());
          await loginRepo!.saveExamId(examId.value.toString());

          final String token = await loginRepo!.getUserToken();
          print("Token : ${token}\nExamId : ${examId.value.toString()}");

          Get.offAllNamed(AppRoutes.homeScreen);
        }
      } else {
        responseModel = LoginResponseModel.fromJson(response.body);
        DialogUtils.showErrorDialog(
          title: 'warning'.tr,
          description: responseModel.message ?? 'error_unknown'.tr,
        );
      }
    } catch (error) {
      closeLoading();

      DialogUtils.showErrorDialog(description: "$error");

      if (kDebugMode) {
        print(
            "There is an error occurred while login request is processing: $error");
      }
    }
  }

  void closeLoading() {
    Get.back();
  }

  //is user logged in
  bool userLoggedIn() {
    return loginRepo!.userLoggedIn();
  }

  bool userLogOutMethod() {
    return loginRepo!.userLoggedOut();
  }

  bool clearSharedData() {
    return loginRepo!.clearSharedData();
  }
}
