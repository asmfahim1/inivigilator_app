import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/app_routes.dart';
import 'package:invigilator_app/core/utils/string_resource.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/common_appbar.dart';
import '../../../core/widgets/text_widget.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final home = Get.find<HomeController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        autoImply: false,
        title: 'dashboard'.tr,
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.logout_outlined,
                color: redColor,
                size: 25,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _profileWidget(),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: _examRooms()),
        ],
      ),
    );
  }

  Widget _profileWidget() {
    Size size = MediaQuery.of(context).size;
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
                'ABC XYZ',
                style: TextStyles.title16,
              ),
              TextWidget(
                'Invigilator\'s id: 147852330011',
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
  }

  Widget _examRooms(){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          physics: const BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Get.toNamed(AppRoutes.studentInfoScreen);
              },
              child: Container(
                height: size.width / 3,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: strokeColor,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget('Building ${index + 1} ', style: TextStyles.regular12,),
                    TextWidget('Room-50${index + 1}', style: TextStyles.regular12,),
                    TextWidget('Total Student-3$index', style: TextStyles.regular12,),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
