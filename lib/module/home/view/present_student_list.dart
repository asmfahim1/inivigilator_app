import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:invigilator_app/core/widgets/exports.dart';
import 'package:invigilator_app/module/home/controller/home_controller.dart';
import 'package:invigilator_app/module/home/view/widgets/attended_student_list_tile_widget.dart';

class AttendanceListScreen extends StatelessWidget {
  AttendanceListScreen({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    homeController.fetchPresentStudent();

    return Scaffold(
      appBar: CommonAppbar(
        showBackArrow: true,
        title: TextWidget(
          'attended_student'.tr,
          style: TextStyles.title20.copyWith(color: whiteColor),
        ),
        actions: [
          GestureDetector(
            onTap: homeController.isAttendanceUploaded.value
                ? null
                : () {
                    homeController.uploadPresentStudentData();
                  },
            child: homeController.isAttendanceUploaded.value
                ? const CircularProgressIndicator()
                : Padding(
                    padding: EdgeInsets.only(
                      right: Dimensions.padding10,
                    ),
                    child: Icon(
                      Icons.file_upload_outlined,
                      size: Dimensions.iconSize25,
                    ),
                  ),
          ),
        ],
      ),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.padding10,
        ),
        child: Obx(() {
          return Column(
            children: [
              Container(
                height: Dimensions.height50,
                width: Dimensions.screenWidth,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.padding10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: blackColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      'attendance'.tr,
                      style: TextStyles.title16,
                    ),
                    TextWidget(
                      '${'total'.tr} : ${homeController.attendedStudents.length}',
                      style: TextStyles.title16,
                    ),
                  ],
                ),
              ),
              homeController.isAttendedFound.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : homeController.attendedStudents.isEmpty
                      ? Expanded(
                          child: Center(
                            child: TextWidget(
                              'empty_attendance_list'.tr,
                              style: TextStyles
                                  .regular16, // Customize the style as needed
                            ),
                          ),
                        )
                      : Expanded(
                          child: AttendedStudentsListTile(
                            attendedStudentList:
                                homeController.attendedStudents,
                          ),
                        ),
            ],
          );
        }),
      ),
    );
  }
}
