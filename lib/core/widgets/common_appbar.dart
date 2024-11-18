import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/utils/colors.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool showBackArrow;
  final bool centerTitle;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final double elevation;

  const CommonAppbar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.centerTitle = true,
    this.leadingIcon,
    this.leadingOnPressed,
    this.actions,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      leading: showBackArrow
          ? InkWell(
        onTap: () => Get.back(),
        child: const Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
              ),
            )
          : leadingIcon != null
          ? InkWell(
        onTap: leadingOnPressed,
        child: Icon(
          leadingIcon,
          color: whiteColor,
        ),
      )
          : null,
      centerTitle: centerTitle,
      title: title,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
