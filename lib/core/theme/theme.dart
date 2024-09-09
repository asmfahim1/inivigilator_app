
import 'package:flutter/material.dart';
import 'package:invigilator_app/core/theme/custome_themes/appbar_theme.dart';
import 'package:invigilator_app/core/theme/custome_themes/bottom_sheet_theme.dart';
import 'package:invigilator_app/core/theme/custome_themes/checkbox_theme.dart';
import 'package:invigilator_app/core/theme/custome_themes/chip_theme.dart';
import 'package:invigilator_app/core/theme/custome_themes/elevated_button_theme.dart';
import 'package:invigilator_app/core/theme/custome_themes/outline_button_theme.dart';
import 'package:invigilator_app/core/theme/custome_themes/text_field_theme.dart';
import 'package:invigilator_app/core/theme/custome_themes/text_theme.dart';

class FAppTheme {
  FAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: FTextTheme.lightTextTheme,
      elevatedButtonTheme: FElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: FOutlineButtonTheme.lightOutlineButtonTheme,
      appBarTheme: FAppBarTheme.lightAppBarTheme,
      bottomSheetTheme: FBottomSheetTheme.lightBottomSheetTheme,
      checkboxTheme: FCheckBoxTheme.lightCheckBoxTheme,
      chipTheme: FChipTheme.lightChipTheme,
      inputDecorationTheme: FTextFieldTheme.lightInputDecorationTheme

      ///this input decoration is for text field theme
      );
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: FTextTheme.darkTextTheme,
      elevatedButtonTheme: FElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: FOutlineButtonTheme.darkOutlineButtonTheme,
      appBarTheme: FAppBarTheme.darkAppBarTheme,
      bottomSheetTheme: FBottomSheetTheme.darkBottomSheetTheme,
      checkboxTheme: FCheckBoxTheme.darkCheckBoxTheme,
      chipTheme: FChipTheme.darkChipTheme,
      inputDecorationTheme: FTextFieldTheme.darkInputDecorationTheme

      ///this input decoration is for text field theme
      );
}
