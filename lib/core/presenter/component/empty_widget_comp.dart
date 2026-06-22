import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';
import 'package:task_tracker_tcl/utils/constant/prompt_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    this.title,
    this.subtitle,
    this.onAction,
    this.actionLabel,
  });

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
              decoration: const BoxDecoration(
                color: ColorConst.paleGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.checklist_rounded,
                color: ColorConst.forestGreen,
                size: 40,
              ),
            ),
            const SizedBox(height: SizeConst.lg),
            Text(
              title ?? PromptConst.emptyTitle,
              style: TextMod.h2(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SizeConst.sm),
            Text(
              subtitle ?? PromptConst.emptySubtitle,
              style: TextMod.body(color: ColorConst.sageGreen),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: SizeConst.xl),
              TextButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded, color: ColorConst.forestGreen),
                label: Text(
                  actionLabel ?? 'Add Task',
                  style: TextMod.subheading(color: ColorConst.forestGreen),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}