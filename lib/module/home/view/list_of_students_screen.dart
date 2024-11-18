import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/app_routes.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:invigilator_app/core/widgets/exports.dart';
import 'package:invigilator_app/module/home/controller/home_controller.dart';
import 'package:invigilator_app/module/home/view/report_submit_screen.dart';
import 'package:invigilator_app/module/home/view/widgets/candidate_info_list_tile_widget.dart';

class StudentsInfo extends StatelessWidget {
  StudentsInfo({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    homeController.insertStudents();
    return Scaffold(
      appBar: CommonAppbar(
        showBackArrow: true,
        title: TextWidget('student_info_title'.tr, style: TextStyles.title20.copyWith(color: whiteColor),),
        actions: [
          IconButton(
            onPressed: (){
              Get.to(() => ReportCheatingScreen());
            },
            icon: Icon(
              Icons.report,
              color: whiteColor,
              size: 25,
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Flexible(
              child: Container(
                width: Dimensions.screenWidth,
                padding: EdgeInsets.symmetric(horizontal: Dimensions.padding10,),
                child: homeController.isStudentFetched.value
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: primaryColor,
                      ),)
                    : homeController.students.isEmpty
                        ? Center(
                            child: TextWidget(
                              'No candidate information found',
                              style: TextStyles
                                  .regular16, // Customize the style as needed
                            ),
                          )
                        : CandidateStudentListTile(
                            studentList: homeController.students,),
              ),
            ),
            if (homeController.students.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(Dimensions.padding20,),
                child: CommonButton(
                  height: Dimensions.height10 * 5,
                  width: Dimensions.screenWidth,
                  buttonColor: blueColor,
                  buttonTitle: 'Start detection',
                  onPressed: () {
                    Get.toNamed(AppRoutes.recognitionScreen);
                  },
                ),
              ),
          ],
        );
      }),
    );
  }
}
