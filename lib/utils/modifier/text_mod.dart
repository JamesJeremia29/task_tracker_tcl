import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';

class TextMod {
  TextMod._();

  //Display
  static TextStyle display({Color? color, FontWeight weight = FontWeight.w700}) =>
      TextStyle(
        fontSize: 32,
        fontWeight: weight,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );

  //Heading
  static TextStyle h1({Color? color, FontWeight weight = FontWeight.w700}) =>
      TextStyle(
        fontSize: 24,
        fontWeight: weight,
        color: color,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle h2({Color? color, FontWeight weight = FontWeight.w600}) =>
      TextStyle(
        fontSize: 20,
        fontWeight: weight,
        color: color,
        height: 1.3,
      );

  static TextStyle h3({Color? color, FontWeight weight = FontWeight.w600}) =>
      TextStyle(
        fontSize: 18,
        fontWeight: weight,
        color: color,
        height: 1.4,
      );

  //Sub-Heading
  static TextStyle subheading({Color? color, FontWeight weight = FontWeight.w500}) =>
      TextStyle(
        fontSize: 16,
        fontWeight: weight,
        color: color,
        height: 1.4,
      );

  static TextStyle subtitle({Color? color, FontWeight weight = FontWeight.w400}) =>
      TextStyle(
        fontSize: 14,
        fontWeight: weight,
        color: color ?? ColorConst.fernGreen,
        height: 1.4,
        letterSpacing: 0.1,
      );

  //Body
  static TextStyle body({Color? color, FontWeight weight = FontWeight.w400}) =>
      TextStyle(
        fontSize: 14,
        fontWeight: weight,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color, FontWeight weight = FontWeight.w400}) =>
      TextStyle(
        fontSize: 12,
        fontWeight: weight,
        color: color,
        height: 1.5,
      );

  //Label
  static TextStyle label({Color? color, FontWeight weight = FontWeight.w500}) =>
      TextStyle(
        fontSize: 12,
        fontWeight: weight,
        color: color ?? ColorConst.sageGreen,
        letterSpacing: 0.5,
        height: 1.4,
      );

  static TextStyle labelLarge({Color? color, FontWeight weight = FontWeight.w600}) =>
      TextStyle(
        fontSize: 13,
        fontWeight: weight,
        color: color ?? ColorConst.sageGreen,
        letterSpacing: 0.4,
      );

  //Button
  static TextStyle button({Color? color, FontWeight weight = FontWeight.w600}) =>
      TextStyle(
        fontSize: 14,
        fontWeight: weight,
        color: color ?? ColorConst.white,
        letterSpacing: 0.5,
      );

  //Caption
  static TextStyle caption({Color? color, FontWeight weight = FontWeight.w400}) =>
      TextStyle(
        fontSize: 11,
        fontWeight: weight,
        color: color,
        height: 1.4,
        letterSpacing: 0.2,
      );
}