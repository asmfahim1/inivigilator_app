import 'package:flutter/material.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:invigilator_app/core/widgets/exports.dart';

class AttendedStudentsListTile extends StatelessWidget {
  final List<Map<String,dynamic>> attendedStudentList;

  const AttendedStudentsListTile({super.key, required this.attendedStudentList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: attendedStudentList.length,
      itemBuilder: (_, index) {
        var student = attendedStudentList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xff764abc),
            child: TextWidget(
              student['id'].toString(),
              style: TextStyles.regular14.copyWith(color: whiteColor,),
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
          trailing: const Icon(Icons.check, color: greenColor,),
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
