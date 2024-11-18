import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/app_routes.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/widgets/exports.dart';
import 'package:invigilator_app/core/widgets/sized_box_height_10.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/styles.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: TextWidget('dashboard'.tr, style: TextStyles.title20.copyWith(color: whiteColor),),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.loginScreen);
            },
            icon: Icon(
              Icons.logout_outlined,
              color: redColor,
              size: Dimensions.iconSize30,
            ),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (shouldPop, dynamic) async {
          await homeController.showWarningContext(context) ?? false;
        },
        child: Column(
          children: [
            _profileWidget(),
            const SizedBoxHeight20(),
            Expanded(child: _examRooms(),),
          ],
        ),
      ),
    );
  }

  Widget _profileWidget() {
    return Container(
      width: Dimensions.screenWidth,
      padding: EdgeInsets.symmetric(vertical: Dimensions.padding15),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Dimensions.radius20 * 1.5),
          bottomRight: Radius.circular(Dimensions.radius20 * 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: blueColor,
            radius: Dimensions.radius20 * 2,
            backgroundImage: const NetworkImage(
              'https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg?size=626&ext=jpg&ga=GA1.1.559178150.1721198416&semt=sph',
            ),
          ),
          const SizedBoxHeight10(),
          TextWidget(
            'Amaz Uddin Shaon',
            style: TextStyles.title16.copyWith(fontSize: Dimensions.font10* 1.8, color: whiteColor),
            overflow: TextOverflow.ellipsis,
          ),
          TextWidget(
            'ID: 2254991056',
            style: TextStyles.regular14.copyWith(color: whiteColor),
            overflow: TextOverflow.ellipsis,
          ),
          TextWidget(
            'amaz@gmail.com',
            style: TextStyles.regular14.copyWith(color: whiteColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _examRooms(){
    return Padding(
      padding: EdgeInsets.all(Dimensions.padding10),
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
            return GestureDetector(
              onTap: (){

                Get.toNamed(AppRoutes.studentInfoScreen);

              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                color: secondaryColor,
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget('Building ${index + 1} ', style: TextStyles.regular14.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                    TextWidget('Room-50${index + 1}', style: TextStyles.regular12.copyWith(color: Colors.white),),
                    TextWidget('Total Student-3$index', style: TextStyles.regular12.copyWith(color: Colors.white),),
                  ],
                ),
              ),
            );
          }),
    );
  }
}