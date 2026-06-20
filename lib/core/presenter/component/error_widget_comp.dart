import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';
import 'package:task_tracker_tcl/utils/constant/prompt_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import 'package:task_tracker_tcl/utils/modifier/button_mod.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SizeConst.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorConst.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: ColorConst.error,
                size: 40,
              ),
            ),
            const SizedBox(height: SizeConst.lg),
            Text('Oops!', style: TextMod.h2()),
            const SizedBox(height: SizeConst.sm),
            Text(
              message ?? 'Something went wrong.',
              style: TextMod.body(color: ColorConst.sageGreen),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: SizeConst.xl),
              AppButton(
                label: PromptConst.retry,
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
                color: ColorConst.forestGreen,
              ),
            ],
          ],
        ),
      ),
    );
  }
}