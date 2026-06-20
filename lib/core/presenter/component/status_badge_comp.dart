import 'package:flutter/material.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/prompt_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';

class StatusBadge extends StatelessWidget {
  final bool isDone;
  final bool large;

  const StatusBadge({super.key, required this.isDone, this.large = false});

  @override
  Widget build(BuildContext context) {
    final color = isDone ? ColorConst.done : ColorConst.pending;
    final label = isDone ? PromptConst.done : PromptConst.pending;
    final icon  = isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: large ? SizeConst.md : SizeConst.sm,
        vertical:   large ? SizeConst.sm : SizeConst.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(SizeConst.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: large ? 16 : 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: large
                ? TextMod.label(color: color)
                : TextMod.caption(color: color),
          ),
        ],
      ),
    );
  }
}