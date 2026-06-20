import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
  });

  const AppButton.outlined({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.color,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final bg    = color ?? ColorConst.forestGreen;
    final child = isLoading
        ? const SizedBox(width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: SizeConst.iconSmall), const SizedBox(width: 6)],
              Text(label, style: TextMod.button()),
            ],
          );

    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: SizeConst.buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: bg),
            foregroundColor: bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConst.radiusMedium)),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: SizeConst.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConst.radiusMedium)),
        ),
        child: child,
      ),
    );
  }
}