import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';

import 'package:invigilator_app/core/utils/styles.dart';import 'package:invigilator_app/core/widgets/common_appbar.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import 'package:invigilator_app/module/home/controller/home_controller.dart';

class ReportCheatingScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  ReportCheatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        showBackArrow: true,
        title: TextWidget("Report of cheating", style: TextStyles.title20.copyWith(color: whiteColor),),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(
                      () => Container(
                    height: Dimensions.height100 * 2,
                    width: Dimensions.width200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: controller.imageFile.value == null
                        ? const Center(child: Text('Tap to upload photo'))
                        : Image.file(
                      controller.imageFile.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.name.value = value,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Roll No.',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.rollNo.value = value,
              ),
              const SizedBox(height: 20),
              Obx(() => TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Exam Name',
                    border: OutlineInputBorder(),
                    hintText: controller.examName.value,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: Dimensions.widthScreenHalf,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Submit Report'),
                    onPressed: controller.submitReport,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}