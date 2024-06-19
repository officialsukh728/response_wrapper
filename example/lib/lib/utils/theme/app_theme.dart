import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/utils/common/AppColors.dart';


ThemeData get getAppThemeData => ThemeData.light(useMaterial3: false).copyWith(
  textTheme: getTextTheme,
  splashColor:AppColors.oceanBlue,
  scrollbarTheme: ScrollbarThemeData(
  ).copyWith(
    trackColor: MaterialStatePropertyAll(AppColors.oceanBlue),
  ),
  primaryColor: AppColors.oceanBlue,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: AppColors.backGroundColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  ),
  colorScheme: const ColorScheme(
    primary: AppColors.oceanBlue,
    secondary: AppColors.primaryColor,
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
    background: AppColors.backGroundColor,
  ),
);

TextTheme get getTextTheme => TextTheme(
      ///Mobile/Header1
      displayLarge: TextStyle(
        fontSize: 20.sp,
        fontFamily: AppFonts.cabinVariable,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      ///Mobile/Header2
      displayMedium: TextStyle(
        fontSize: 20.sp,
        fontFamily: AppFonts.cabinVariable,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      ///Mobile/Header3
      displaySmall: TextStyle(
        fontSize: 9.sp,
        fontFamily: AppFonts.cabinVariable,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      ///Mobile/Header4
      headlineMedium: TextStyle(
        fontSize: 16.sp,
        fontFamily: AppFonts.cabinVariable,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),

      ///Mobile/Text Body
      bodyLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        fontFamily: AppFonts.cabinVariable,
        height: 1.5,
        color: Colors.black,
      ),

      ///Mobile/Additional
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: AppFonts.cabinVariable,
        color: Colors.black,
      ),

      ///Mobile/Additional2
      titleMedium: TextStyle(
        fontSize: 15.sp,
        fontFamily: AppFonts.cabinVariable,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),

      ///Desktop/Additional
      titleSmall: TextStyle(
        fontSize: 12.sp,
        fontFamily: AppFonts.cabinVariable,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );

class AppFonts {
  static const String cabinVariable = "CabinStatic";
  static const String righteous = "Righteous";
}
