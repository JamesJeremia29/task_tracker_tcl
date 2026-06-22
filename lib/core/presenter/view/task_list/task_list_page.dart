import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_tcl/utils/constant/color_const.dart';
import 'package:task_tracker_tcl/utils/constant/size_const.dart';
import 'package:task_tracker_tcl/utils/constant/prompt_const.dart';
import 'package:task_tracker_tcl/utils/modifier/text_mod.dart';
import 'package:task_tracker_tcl/core/presenter/component/empty_widget_comp.dart';
import 'package:task_tracker_tcl/core/presenter/component/error_widget_comp.dart';
import 'package:task_tracker_tcl/core/presenter/component/loading_widget_comp.dart';
import 'package:task_tracker_tcl/core/presenter/component/task_card_comp.dart';
import '../add_task/add_task_page.dart';
import '../task_detail/task_detail_page.dart';
import 'task_list_cubit.dart';
import 'task_list_state.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';

class TaskListPage extends StatelessWidget {
  final TaskRepository repository;
  const TaskListPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskListCubit(repository)..loadTasks(),
      child: _TaskListView(repository: repository),
    );
  }
}

class _TaskListView extends StatefulWidget {
  // ← change to StatefulWidget
  final TaskRepository repository;
  const _TaskListView({required this.repository});

  @override
  State<_TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<_TaskListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0; //trigger load

    if (currentScroll >= maxScroll - threshold) {
      context.read<TaskListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(PromptConst.taskList, style: TextMod.h2(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<TaskListCubit>().loadTasks(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskPage(repository: widget.repository),
            ),
          );
          if (context.mounted) context.read<TaskListCubit>().loadTasks();
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: BlocBuilder<TaskListCubit, TaskListState>(
        builder: (context, state) {
          if (state is TaskListLoading) {
            return const LoadingWidget(message: 'Loading tasks...');
          }
          if (state is TaskListEmpty) {
            return EmptyStateWidget(
              onAction: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTaskPage(repository: widget.repository),
                  ),
                );
                if (context.mounted) context.read<TaskListCubit>().loadTasks();
              },
            );
          }
          if (state is TaskListError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<TaskListCubit>().loadTasks(),
            );
          }

          var tasks = <TaskModel>[];
          var hasMore = true;
          var isLoadingMore = false;
          var totalCount = 0;
          var doneCount = 0;
          var pendingCount = 0;

          if (state is TaskListLoaded) {
            tasks = state.tasks;
            hasMore = state.hasMore;
            totalCount = state.totalCount;
            doneCount = state.doneCount;
            pendingCount = state.pendingCount;
          } else if (state is TaskListLoadingMore) {
            tasks = state.tasks;
            isLoadingMore = true;
            hasMore = true;
          }

          if (tasks.isEmpty) return const SizedBox();

          return Column(
            children: [
              _SummaryBar(
                total: totalCount,
                done: doneCount,
                pending: pendingCount,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: ColorConst.forestGreen,
                  onRefresh: () => context.read<TaskListCubit>().loadTasks(),
                  child: ListView.builder(
                    controller: _scrollController, // ← attach controller
                    padding: const EdgeInsets.only(
                      top: SizeConst.sm,
                      bottom: SizeConst.xxl,
                    ),
                    itemCount: tasks.length + (hasMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      //loading spinner or end indicator for last item
                      if (i == tasks.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: SizeConst.lg),
                          child: isLoadingMore
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConst.forestGreen,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Scroll up to refresh',
                                    style: TextMod.caption(
                                        color: ColorConst.sageGreen),
                                  ),
                                ),
                        );
                      }

                      final task = tasks[i];
                      return TaskCard(
                        task: task,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailPage(
                                taskId: task.id,
                                repository: widget.repository,
                              ),
                            ),
                          );
                          if (context.mounted) {
                            context.read<TaskListCubit>().loadTasks();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

//Summary Bar
class _SummaryBar extends StatelessWidget {
  final int total, done, pending;
  const _SummaryBar({
    required this.total,
    required this.done,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(SizeConst.md),
      padding: const EdgeInsets.all(SizeConst.md),
      decoration: BoxDecoration(
        color: ColorConst.paleGreen,
        borderRadius: BorderRadius.circular(SizeConst.radiusLarge),
        border: Border.all(color: ColorConst.mintGreen),
      ),
      child: Row(
        children: [
          _StatChip(
              label: 'Total', value: total, color: ColorConst.forestGreen),
          const SizedBox(width: SizeConst.sm),
          _StatChip(
              label: 'Pending', value: pending, color: ColorConst.pending),
          const SizedBox(width: SizeConst.sm),
          _StatChip(label: 'Done', value: done, color: ColorConst.done),
          const Spacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  total == 0 ? '0%' : '${((done / total) * 100).round()}%',
                  style: TextMod.label(color: ColorConst.forestGreen),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(SizeConst.radiusFull),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : done / total,
                    minHeight: 6,
                    backgroundColor: ColorConst.mintGreen,
                    valueColor:
                        const AlwaysStoppedAnimation(ColorConst.forestGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: TextMod.h3(color: color)),
        Text(label, style: TextMod.caption(color: ColorConst.sageGreen)),
      ],
    );
  }
}
