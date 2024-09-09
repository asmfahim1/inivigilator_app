import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/styles.dart';

class CommonDropDown extends StatelessWidget {
  final String item;
  final List<String> items;
  final void Function(String?)? onChanged;
  final double? width;
  final double? height;
  final Color? color;
  const CommonDropDown({
    super.key,
    required this.item,
    required this.items,
    this.width,
    this.height,
    this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding:
      const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: textFieldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          padding: const EdgeInsets.only(left: 15),
          isExpanded: true,
          iconEnabledColor: color,
          value: item,
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyles.regular14.copyWith(
                  color: color,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}