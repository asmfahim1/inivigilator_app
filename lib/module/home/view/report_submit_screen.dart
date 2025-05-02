import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/colors.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/utils/styles.dart';
import 'package:invigilator_app/core/widgets/common_appbar.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import 'package:invigilator_app/module/home/controller/unfairness_controller.dart';

class ReportCheatingScreen extends StatelessWidget {
  final UnfairnessController controller = Get.put(UnfairnessController());

  ReportCheatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        showBackArrow: true,
        title: TextWidget("Unfairness Form", style: TextStyles.title20.copyWith(color: whiteColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => SingleChildScrollView(
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
                      child: Obx(() => Container(
                        height: Dimensions.height100 * 2,
                        width: Dimensions.width200,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: report.imageFile.value == null
                            ? const Center(child: Text('Tap to upload photo'))
                            : Image.file(report.imageFile.value!, fit: BoxFit.cover),
                      )),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      onChanged: (value) => report.name.value = value,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Roll No.', border: OutlineInputBorder()),
                      onChanged: (value) => report.rollNo.value = value,
                    ),
                    const SizedBox(height: 10),
                    Obx(() => TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Exam Name',
                        border: const OutlineInputBorder(),
                        hintText: report.examName.value,
                      ),
                    )),
                    const Divider(height: 30, thickness: 1),
                  ],
                );
              }),

              Center(
                child: Container(
                  width: Dimensions.widthScreenHalf,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.hardEdge,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Submit Report'),
                    onPressed: controller.submitReport,
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addNewReport,
        child: const Icon(Icons.add),
      ),
    );
  }
}

