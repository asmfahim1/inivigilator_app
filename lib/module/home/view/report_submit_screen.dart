import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/styles.dart';
import 'package:invigilator_app/core/widgets/common_appbar.dart';
import 'package:invigilator_app/core/widgets/common_text_field_widget.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import 'package:invigilator_app/module/home/controller/unfairness_controller.dart';

class ReportCheatingScreen extends StatelessWidget {
  ReportCheatingScreen({super.key});

  final UnfairnessController controller = Get.put(UnfairnessController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        showBackArrow: true,
        title: TextWidget("Unfairness Form",
            style: TextStyles.title20.copyWith(color: whiteColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(controller.reports.length, (index) {
                    final report = controller.reports[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Form ${index + 1}", style: TextStyles.title16),
                            if (controller.reports.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => controller.removeReport(index),
                              ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => controller.pickImage(index),
                          child: Obx(
                            () => Container(
                              height: Dimensions.height100 * 2,
                              width: Dimensions.width200,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: report.imageFile.value == null
                                  ? Center(
                                      child: Text(
                                        'upload_photo'.tr,
                                      ),
                                    )
                                  : Image.file(
                                      report.imageFile.value!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        if (report.imageFile.value == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Image is required',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          labelText: 'name'.tr,
                          isRequired: true,
                          controller: report.nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CommonTextField(
                          labelText: 'roll'.tr,
                          isRequired: true,
                          controller: report.rollNoController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Roll No. is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Obx(() => CommonTextField(
                            labelText: 'exam_name'.tr,
                            isRequired: true,
                            hintText: report.examName.value,
                          ),
                        ),
                        const Divider(height: 30, thickness: 1),
                      ],
                    );
                  }),
                  Obx(
                    () => Center(
                      child: Container(
                        width: Dimensions.screenWidth,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: ElevatedButton.icon(
                                icon: const Icon(Icons.send_outlined),
                                label: const Text('Submit Report'),
                                onPressed: controller.submitReport,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  disabledBackgroundColor: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addNewReport,
        child: const Icon(Icons.add),
      ),
    );
  }
}


