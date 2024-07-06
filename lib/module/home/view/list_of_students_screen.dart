import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/app_routes.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:invigilator_app/core/widgets/exports.dart';
import 'package:invigilator_app/module/home/controller/home_controller.dart';

class StudentsInfo extends StatelessWidget {
  StudentsInfo({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    homeController.insertStudents();
    return Scaffold(
      appBar: CommonAppbar(
        autoImply: true,
        title: 'student_info_title'.tr,
      ),
      body: Column(
        children: [
          Container(
            height: Dimensions.screenHeight * .78,
            width: Dimensions.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() {
              return homeController.isStudentFetched.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: homeController.students.length,
                itemBuilder: (_, index) {
                  var student = homeController.students[index];
                  print('------------${student}-------------');
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xff764abc),
                      child: TextWidget(
                        '${student['id']}',
                        style: TextStyles.title16.copyWith(fontWeight: FontWeight.bold, color: whiteColor),
                      ),
                    ),
                    title: TextWidget(
                      'Name: ${student['student_name']}',
                      style: TextStyles.title16,
                    ),
                    subtitle: TextWidget(
                      'exam : ${student['exam_name']}',
                      style: TextStyles.title16,
                    ),
                    trailing: Icon(Icons.check, color: greenColor),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 1.2,
                  );
                },
              );
            }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CommonButton(
                buttonColor: blueColor,
                buttonTitle: 'Start detection',
                onPressed: () {
                  Get.toNamed(AppRoutes.recognitionScreen);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
