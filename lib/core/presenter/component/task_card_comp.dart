import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import '../view/task_list/task_list_cubit.dart';
import 'package:task_tracker_tcl/core/presenter/component/status_badge_comp.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeConst.md,
        vertical:   SizeConst.xs,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(SizeConst.radiusLarge),
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(SizeConst.radiusLarge),
              border: Border.all(
                color: task.isDone
                    ? ColorConst.done.withValues(alpha: 0.2)
                    : ColorConst.mintGreen.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(SizeConst.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle checkbox
                  GestureDetector(
                    onTap: () => context
                        .read<TaskListCubit>()
                        .toggleStatus(task.id, task.status),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(top: 2, right: SizeConst.md),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isDone
                            ? ColorConst.done
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isDone
                              ? ColorConst.done
                              : ColorConst.sageGreen,
                          width: 2,
                        ),
                      ),
                      child: task.isDone
                          ? const Icon(Icons.check_rounded,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextMod.subheading().copyWith(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isDone
                                      ? ColorConst.sageGreen
                                      : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: SizeConst.sm),
                            StatusBadge(isDone: task.isDone),
                          ],
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: SizeConst.xs),
                          Text(
                            task.description,
                            style: TextMod.body(color: ColorConst.sageGreen),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: SizeConst.sm),
                        Text(
                          _formatDate(task.createdAt),
                          style: TextMod.caption(color: ColorConst.sageGreen),
                        ),
                      ],
                    ),
                  ),

                  // Chevron
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: ColorConst.sageGreen,
                    size: SizeConst.iconMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}