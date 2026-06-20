import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/duration_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(BuildContext context, String message) {
    _show(context, message, ColorConst.done, Icons.check_circle_outline);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, ColorConst.error, Icons.error_outline);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, ColorConst.fernGreen, Icons.info_outline);
  }

  static void _show(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: DurationConst.snackbar,
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(message, style: TextMod.body(color: Colors.white))),
            ],
          ),
        ),
      );
  }
}