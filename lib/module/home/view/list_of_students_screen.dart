import 'package:flutter/material.dart';
import 'package:invigilator_app/core/utils/exports.dart';
import 'package:invigilator_app/core/widgets/exports.dart';

class StudentsInfo extends StatefulWidget {
  const StudentsInfo({Key? key}) : super(key: key);

  @override
  State<StudentsInfo> createState() => _StudentsInfoState();
}

class _StudentsInfoState extends State<StudentsInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CommonAppbar(
        leading: Icon(Icons.arrow_back_outlined, color: blackColor,),
        title: 'Student\'s info',
      ),
      body: Column(
        children: [
          Container(
            height: size.height / 1.3,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 38,
              itemBuilder: (_, index){
                return Container(
                  height: size.height / 6,
                  width: size.width,
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
                            'Student Name$index',
                            style: TextStyles.title16,
                          ),
                          TextWidget(
                            'id: 14785233001$index',
                            style: TextStyles.title16,
                          ),
                          TextWidget(
                            'exam : BCS exam',
                            style: TextStyles.title16,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: CommonButton(
                btnHeight: size.height / 20,
                width: size.width / 1.9,
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
