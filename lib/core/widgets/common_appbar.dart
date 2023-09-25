import 'package:flutter/material.dart';
import 'package:invigilator_app/core/widgets/text_widget.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import 'back_button.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppbar({
    Key? key,
    this.centerTitle = true,
    this.leading = const BackButtonWidget(),
    this.title,
    this.flexibleSpace = const SizedBox(),
    this.actions = const [SizedBox()],
  }) : super(key: key);

  final Widget leading;
  final String? title;
  final Widget flexibleSpace;
  final bool centerTitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: AppBar(
        backgroundColor: whiteColor,
        centerTitle: centerTitle,
        title: title == null
            ? const SizedBox()
            : TextWidget(
                title!,
                style: TextStyles.regular18.copyWith(
                  color: darkGrayColor,
                ),
              ),
        flexibleSpace: flexibleSpace,
        elevation: 0,
        leading: leading,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
