import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppbar({
    super.key,
    this.autoImply = true,
    this.centerTitle = true,
    this.title,
    this.titleColor,
    this.flexibleSpace = const SizedBox(),
    this.actions = const [SizedBox()],
  });

  final bool? autoImply;
  final String? title;
  final Color? titleColor;
  final Widget flexibleSpace;
  final bool centerTitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: AppBar(
        backgroundColor: primaryColor,
        leading: autoImply!
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: Dimensions.iconSize25,
                  color: primaryColor,
                ),
              )
            : const SizedBox(),
        centerTitle: centerTitle,
        title: title == null
            ? const SizedBox()
            : TextWidget(
                title!,
                style: TextStyles.title20.copyWith(
                  color: titleColor ?? whiteColor,
                ),
              ),
        flexibleSpace: flexibleSpace,
        elevation: 0,
        automaticallyImplyLeading: autoImply!,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
