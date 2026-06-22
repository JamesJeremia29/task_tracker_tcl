import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/utils/constant/prompt_const.dart';
import 'package:task_tracker_tcl/utils/modifier/button_mod.dart';
import 'package:task_tracker_tcl/utils/modifier/snackbar_mod.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import 'package:task_tracker_tcl/core/presenter/component/error_widget_comp.dart';
import 'package:task_tracker_tcl/core/presenter/component/loading_widget_comp.dart';
import 'package:task_tracker_tcl/core/presenter/component/status_badge_comp.dart';
import 'task_detail_cubit.dart';
import 'task_detail_state.dart';

class TaskDetailPage extends StatelessWidget {
  final String         taskId;
  final TaskRepository repository;

  const TaskDetailPage({
    super.key,
    required this.taskId,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskDetailCubit(repository)..loadTask(taskId),
      child: const _TaskDetailView(),
    );
  }
}

class _TaskDetailView extends StatelessWidget {
  const _TaskDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskDetailCubit, TaskDetailState>(
      listenWhen: (prev, curr) =>
          curr is TaskDetailError ||
          (curr is TaskDetailLoaded && prev is TaskDetailUpdating),
      listener: (context, state) {
        if (state is TaskDetailError) {
          AppSnackbar.error(context, state.message);
        }
        if (state is TaskDetailLoaded) {
          AppSnackbar.success(context, PromptConst.taskUpdated);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(PromptConst.taskDetail,
                style: TextMod.h2(color: Colors.white)),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TaskDetailState state) {
    if (state is TaskDetailLoading) {
      return const LoadingWidget(message: 'Loading task...');
    }

    if (state is TaskDetailError) {
      return AppErrorWidget(
        message: state.message,
        onRetry: () => context.read<TaskDetailCubit>().loadTask(
          // re-fetch using same id stored in cubit
          (context.read<TaskDetailCubit>().state is TaskDetailError)
              ? ''
              : '',
        ),
      );
    }

    //Both Loaded and Updating carry a task — extract it
    final TaskModel? task = switch (state) {
      TaskDetailLoaded()   => state.task,
      TaskDetailUpdating() => state.task,
      _                    => null,
    };

    if (task == null) return const SizedBox();

    final isUpdating = state is TaskDetailUpdating;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(SizeConst.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: SizeConst.sm),

            //Status & Date
            Row(
              children: [
                StatusBadge(isDone: task.isDone, large: true),
                const Spacer(),
                Text(
                  _formatDate(task.createdAt),
                  style: TextMod.caption(color: ColorConst.sageGreen),
                ),
              ],
            ),

            const SizedBox(height: SizeConst.lg),

            //Title
            Text('Title',
                style: TextMod.label(color: ColorConst.forestGreen)),
            const SizedBox(height: SizeConst.xs),
            Text(task.title, style: TextMod.h2()),

            const SizedBox(height: SizeConst.lg),
            const Divider(color: ColorConst.mintGreen),
            const SizedBox(height: SizeConst.lg),

            //Description
            Text('Description',
                style: TextMod.label(color: ColorConst.forestGreen)),
            const SizedBox(height: SizeConst.sm),
            Container(
              width:   double.infinity,
              padding: const EdgeInsets.all(SizeConst.md),
              decoration: BoxDecoration(
                color:        ColorConst.paleGreen,
                borderRadius: BorderRadius.circular(SizeConst.radiusMedium),
                border:       Border.all(color: ColorConst.mintGreen),
              ),
              child: Text(
                task.description.isEmpty
                    ? 'No description provided.'
                    : task.description,
                style: TextMod.body(
                  color: task.description.isEmpty
                      ? ColorConst.sageGreen
                      : ColorConst.darkCharcoal,
                ),
              ),
            ),

            const SizedBox(height: SizeConst.xxl),

            //Toggle Status Button
            AppButton(
              label:     task.isDone
                  ? PromptConst.markPending
                  : PromptConst.markDone,
              icon:      task.isDone
                  ? Icons.radio_button_unchecked_rounded
                  : Icons.check_circle_outline_rounded,
              isLoading: isUpdating,
              color:     task.isDone ? ColorConst.pending : ColorConst.done,
              onPressed: isUpdating
                  ? null
                  : () => context
                      .read<TaskDetailCubit>()
                      .toggleStatus(task.id, task.status),
            ),

            const SizedBox(height: SizeConst.lg),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return 'Created ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}