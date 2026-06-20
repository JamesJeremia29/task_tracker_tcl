import 'package:task_tracker_tcl/core/data/model/task_model.dart';

abstract class TaskListState {}

class TaskListInitial  extends TaskListState {}
class TaskListLoading  extends TaskListState {}
class TaskListEmpty    extends TaskListState {}
class TaskListError    extends TaskListState {
  final String message;
  TaskListError(this.message);
}
class TaskListLoadingMore extends TaskListState {
  final List<TaskModel> tasks;
  TaskListLoadingMore(this.tasks);
}
class TaskListLoaded extends TaskListState {
  final List<TaskModel> tasks;
  final bool hasMore;
  final int  currentPage;
  final int  totalCount;
  final int  doneCount;
  final int  pendingCount;

  TaskListLoaded(
    this.tasks, {
    this.hasMore      = true,
    this.currentPage  = 0,
    this.totalCount   = 0,
    this.doneCount    = 0,   // ← from DB
    this.pendingCount = 0,   // ← from DB
  });
}