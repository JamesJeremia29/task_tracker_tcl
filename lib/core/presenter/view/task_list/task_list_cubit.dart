import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/utils/constant/error_const.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';
import 'task_list_state.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';

class TaskListCubit extends Cubit<TaskListState> {
  final TaskRepository repository;
  static const int _pageSize = 10;

  TaskListCubit(this.repository) : super(TaskListInitial());

  Future<void> loadTasks() async {
    emit(TaskListLoading());
    try {
      final results = await Future.wait([
        repository.getTasks(page: 0),
        repository.getTasksCount(),
        repository.getTasksCountByStatus('done'),
        repository.getTasksCountByStatus('pending'),
      ]);

      final tasks = results[0] as List<TaskModel>;
      final totalCount = results[1] as int;
      final doneCount = results[2] as int;
      final pendingCount = results[3] as int;

      if (tasks.isEmpty) {
        emit(TaskListEmpty());
      } else {
        emit(TaskListLoaded(
          tasks,
          hasMore: tasks.length >= _pageSize,
          currentPage: 0,
          totalCount: totalCount,
          doneCount: doneCount,
          pendingCount: pendingCount,
        ));
      }
    } catch (e) {
      emit(TaskListError(ErrorConst.parse(e)));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! TaskListLoaded) return;
    if (!current.hasMore) return;

    emit(TaskListLoadingMore(current.tasks));

    try {
      final nextPage = current.currentPage + 1;
      final newTasks = await repository.getTasks(page: nextPage);
      final allTasks = [...current.tasks, ...newTasks];

      emit(TaskListLoaded(
        allTasks,
        hasMore: newTasks.length >= _pageSize,
        currentPage: nextPage,
        totalCount: current.totalCount, // ← keep
        doneCount: current.doneCount, // ← keep
        pendingCount: current.pendingCount, // ← keep
      ));
    } catch (e) {
      emit(TaskListLoaded(
        current.tasks,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
        totalCount: current.totalCount,
        doneCount: current.doneCount,
        pendingCount: current.pendingCount,
      ));
      emit(TaskListError(ErrorConst.parse(e)));
    }
  }

  Future<void> toggleStatus(String id, String currentStatus) async {
    try {
      final newStatus = currentStatus == 'done' ? 'pending' : 'done';
      await repository.updateTaskStatus(id, UpdateTask(status: newStatus));
      await loadTasks(); // refresh from page 0
    } catch (e) {
      emit(TaskListError(ErrorConst.parse(e)));
    }
  }
}
