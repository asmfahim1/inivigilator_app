import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/styles.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import 'package:invigilator_app/module/auth/login/controller/login_controller.dart';

class ExamDropdown extends StatelessWidget {
  const ExamDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        if (controller.isExamListLoaded.value) {
          return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              )); // Show loading indicator while fetching data
        }

        if (controller.examList.isEmpty) {
          return TextWidget(
            'null_exam_list'.tr,
            style: TextStyles.regular14.copyWith(color: redColor),
          );
        }

        return Container(
          height: Dimensions.height10 * 5.7,
          width: Dimensions.screenWidth,
          padding: EdgeInsets.only(left: Dimensions.padding10, right: Dimensions.padding10),
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: Dimensions.padding10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DropdownButton<String>(
            underline: const SizedBox(),
            iconSize: Dimensions.iconSize30,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            items: controller.examList.map((exam) {
              return DropdownMenuItem<String>(
                value: exam.name!,
                child: Text(exam.name!),
              );
            }).toList(),
            onChanged: (selectedExam) {
              controller.setSelectedValue(selectedExam!);
              final exam = controller.examList
                  .firstWhere((element) => element.name! == selectedExam);
              controller.examType.value = exam.name!;
              controller.examId.value = exam.id!;
            },
            hint: TextWidget(
              controller.examType.value,
              style: TextStyles.title16,
            ),
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
