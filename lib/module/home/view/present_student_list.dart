import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:invigilator_app/core/widgets/exports.dart';
import 'package:invigilator_app/module/home/controller/home_controller.dart';
import 'package:invigilator_app/module/home/view/recognition_screen.dart';

class AttendanceListScreen extends StatelessWidget {
  AttendanceListScreen({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    homeController.fetchPresentStudent();

    return Scaffold(
      appBar: CommonAppbar(
        autoImply: true,
        title: 'attended_student'.tr,
      ),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(() {
          return homeController.isAttendedFound.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeController.attendedStudents.length,
                  itemBuilder: (_, index) {
                    var student = homeController.attendedStudents[index];
                    print('------------$student-------------');
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xff764abc),
                        child: TextWidget(
                          "${student['id'].toString()}",
                          style:
                              TextStyles.regular14.copyWith(color: whiteColor),
                        ),
                      ),
                      title: TextWidget(
                        'Name: ${student['name']}',
                        style: TextStyles.title16,
                      ),
                      subtitle: TextWidget(
                        'Matching distance: ${student['distance'].toStringAsFixed(2)}',
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
    );
  }
}
