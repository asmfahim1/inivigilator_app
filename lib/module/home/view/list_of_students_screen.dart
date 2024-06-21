import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            height: Dimensions.screenHeight * .8,
            width: Dimensions.screenWidth,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(() {
              return homeController.isStudentFetched.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: homeController.students.length,
                      itemBuilder: (_, index) {
                        var student = homeController.students[index];
                        return Container(
                          height: Dimensions.height100,
                          width: Dimensions.screenWidth,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: blueColor,
                                radius: 35,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    'Name: ${student['student_name']}',
                                    style: TextStyles.title16,
                                  ),
                                  TextWidget(
                                    'id: ${student['student_id']}',
                                    style: TextStyles.title16,
                                  ),
                                  TextWidget(
                                    'exam : ${student['exam_name']}',
                                    style: TextStyles.title16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
            }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: CommonButton(
                btnHeight: Dimensions.height40,
                width: Dimensions.width180,
                buttonColor: blueColor,
                buttonTitle: 'Start detection',
                onTap: () {
                  //login method will call
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
