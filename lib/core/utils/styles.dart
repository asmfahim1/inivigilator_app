import 'package:flutter/cupertino.dart';
import 'package:invigilator_app/core/utils/pref_helper.dart';
import 'colors.dart';

class TextStyles {
  static TextStyle title32 = TextStyle(
    fontFamily: PrefHelper.getLanguage() == 1 ? 'HindSiliguri' : 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 32,
    color: blackColor,
  );
  static final title22 = title32.copyWith(fontSize: 22);
  static final title20 = title32.copyWith(fontSize: 20);
  static final title18 = title32.copyWith(fontSize: 18);
  static final title16 = title32.copyWith(fontSize: 16);
  static final title13 = title32.copyWith(fontSize: 13);


  static final regular16 = TextStyle(
    fontFamily: PrefHelper.getLanguage() == 1 ? 'HindSiliguri' : 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
  static final regular18 = regular16.copyWith(fontSize: 18);
  static final regular15 = regular16.copyWith(fontSize: 15);
  static final regular14 = regular16.copyWith(
    fontSize: 14,
  );
  static final regular14White = regular16.copyWith(
    fontSize: 14,
    color: whiteColor,
  );
  static final regular12 = regular16.copyWith(
    fontSize: 12,
  );

  static final title11 = title32.copyWith(
    fontSize: 11,
  );
}
