import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.back();
      },
      child: const SizedBox(
        height: 56,
        width: 56,
        child: Center(
          child: SizedBox(
            width: 25,
            height: 25,
            child: Icon(Icons.arrow_back_outlined, color: blackColor,),
          ),
        ),
      ),
    );
  }
}
