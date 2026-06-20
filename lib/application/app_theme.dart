import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';

class AppTheme {
  AppTheme._();

//Light App Theme
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: ColorConst.forestGreen,
          secondary: ColorConst.fernGreen,
          tertiary: ColorConst.sageGreen,
          surface: ColorConst.white,
          surfaceContainerHighest: ColorConst.paleGreen,
          onPrimary: ColorConst.white,
          onSecondary: ColorConst.white,
          onSurface: ColorConst.darkCharcoal,
          error: ColorConst.error,
        ),
        scaffoldBackgroundColor: ColorConst.softWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorConst.forestGreen,
          foregroundColor: ColorConst.white,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: ColorConst.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorConst.forestGreen,
          foregroundColor: ColorConst.white,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: ColorConst.paleGreen,
          labelStyle: const TextStyle(color: ColorConst.forestGreen),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dividerColor: ColorConst.mintGreen,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorConst.paleGreen,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorConst.sageGreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: ColorConst.forestGreen, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorConst.mintGreen),
          ),
        ),
      );

//Dark App Theme
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: ColorConst.sageGreen,
          secondary: ColorConst.fernGreen,
          tertiary: ColorConst.mintGreen,
          surface: ColorConst.darkSurface,
          surfaceContainerHighest: ColorConst.darkCard,
          onPrimary: ColorConst.darkCharcoal,
          onSecondary: ColorConst.white,
          onSurface: ColorConst.softWhite,
          error: ColorConst.error,
        ),
        scaffoldBackgroundColor: ColorConst.darkCharcoal,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorConst.darkSurface,
          foregroundColor: ColorConst.sageGreen,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: ColorConst.darkCard,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorConst.sageGreen,
          foregroundColor: ColorConst.darkCharcoal,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: ColorConst.darkCard,
          labelStyle: const TextStyle(color: ColorConst.sageGreen),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        dividerColor: ColorConst.darkCard,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorConst.darkCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorConst.fernGreen),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorConst.sageGreen, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: ColorConst.darkCard),
          ),
        ),
      );
}
