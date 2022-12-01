import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

ThemeData getAoolicationTheme() {
  return ThemeData(
    //Main Colors
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.gray1,
    splashColor: ColorManager.lightPrimary, //repple effect color//
    errorColor: ColorManager.error,
    //Card Theme
    cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.gray,
      elevation: AppSize.s4,
    ),
    //App Bar Theme
    appBarTheme: AppBarTheme(
      color: ColorManager.primary,
      centerTitle: true,
      shadowColor: ColorManager.white,
      elevation: AppSize.s4,
      titleTextStyle:
          getRegularStyle(color: ColorManager.white, fontSize: AppSize.s16),
    ),
    //button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      buttonColor: ColorManager.primary,
      disabledColor: ColorManager.gray,
      splashColor: ColorManager.lightPrimary,
    ),
    //ElevatedButton Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
            color: ColorManager.primary, fontSize: FontSize.s17),
        backgroundColor: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),
    //Text Theme
    textTheme: TextTheme(
      displayLarge: getSemiBoldStyle(
          color: ColorManager.darkGray, fontSize: FontSize.s16),
      headlineLarge:
          getSemiBoldStyle(color: ColorManager.darkGray, fontSize: AppSize.s16),
      headlineMedium:
          getRegularStyle(color: ColorManager.darkGray, fontSize: AppSize.s14),
      titleMedium:
          getMeiumStyle(color: ColorManager.primary, fontSize: AppSize.s16),
      titleSmall:
          getRegularStyle(color: ColorManager.white, fontSize: AppSize.s18),
      labelSmall:
          getBoldStyle(color: ColorManager.primary, fontSize: AppSize.s12),
      labelLarge:
          getRegularStyle(color: ColorManager.gray2, fontSize: AppSize.s12),
      bodyMedium:
          getMeiumStyle(color: ColorManager.primary, fontSize: AppSize.s14),
      bodyLarge:
          getRegularStyle(color: ColorManager.gray1, fontSize: AppSize.s14),
      bodySmall: getRegularStyle(color: ColorManager.gray),
      displaySmall:
          getSemiBoldStyle(color: ColorManager.primary, fontSize: AppSize.s18),
      labelMedium:
          getMeiumStyle(color: ColorManager.gray2, fontSize: AppSize.s14),
      titleLarge:
          getRegularStyle(color: ColorManager.gray, fontSize: AppSize.s14),
    ),
    //Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      hintStyle:
          getRegularStyle(color: ColorManager.gray, fontSize: FontSize.s14),
      labelStyle:
          getMeiumStyle(color: ColorManager.gray, fontSize: FontSize.s14),
      errorStyle: getRegularStyle(color: ColorManager.error),
      //Enabled Border
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.gray, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      //Focused Border
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      //Error Border
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      //Disabled Border
      disabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.darkGray, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      //Focused Error Border//////////
      focusedErrorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
    ),
  );
}
