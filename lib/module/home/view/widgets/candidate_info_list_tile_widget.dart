import 'package:flutter/material.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/styles.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';

class CandidateStudentListTile extends StatelessWidget {

  final List<Map<String,dynamic>> studentList;

  const CandidateStudentListTile({super.key, required this.studentList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: studentList.length,
      itemBuilder: (_, index) {
        var student = studentList[index];
        return ListTile(
          leading: CircleAvatar(
            radius: Dimensions.radius12 * 2,
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
            'Exam: ${student['exam_name']}',
            style: TextStyles.title16,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 1.2,
        );
      },
    );
  }
}
