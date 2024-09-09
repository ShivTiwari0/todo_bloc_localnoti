import 'package:flutter/material.dart';

class AppColors {
  static Color accent =  Colors.amber;
  static Color text = const Color(0xff212121);
  static Color textLight = const Color(0xff8a8a8a);
  static Color white = const Color(0xffffffff); 
  static Color darkgery =const Color(0xFF121212);
  static Color lightGreyTextColor =const Color(0xFFE0E0E0);
}

class Themes {
  static ThemeData defaultTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.darkgery, 
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.darkgery,
          iconTheme: IconThemeData(color: AppColors.white),
          titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.lightGreyTextColor)),
      colorScheme: ColorScheme.light(
          primary: AppColors.accent, secondary: AppColors.accent));
}

class TextStyles {
  static TextStyle heading1 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.lightGreyTextColor, fontSize: 48);

  static TextStyle heading2 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.lightGreyTextColor, fontSize: 32);

  static TextStyle heading3 = TextStyle(
      fontWeight: FontWeight.bold, color: AppColors.lightGreyTextColor, fontSize: 24);

  static TextStyle body1 = TextStyle(
      fontWeight: FontWeight.normal, color: AppColors.lightGreyTextColor, fontSize: 18);

  static TextStyle body2 = TextStyle(
      fontWeight: FontWeight.normal, color: AppColors.lightGreyTextColor, fontSize: 16);
}
