import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/utils/constant/error_const.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';
import 'task_detail_state.dart';

class TaskDetailCubit extends Cubit<TaskDetailState> {
  final TaskRepository repository;

  TaskDetailCubit(this.repository) : super(TaskDetailInitial());

  Future<void> loadTask(String id) async {
    emit(TaskDetailLoading());
    try {
      final task = await repository.getTaskById(id);
      emit(TaskDetailLoaded(task));
    } catch (e) {
      emit(TaskDetailError(ErrorConst.parse(e)));
    }
  }

  Future<void> toggleStatus(String id, String currentStatus) async {
    final current = state;
    if (current is! TaskDetailLoaded) return;

    emit(TaskDetailUpdating(current.task));
    try {
      final newStatus = currentStatus == 'done'? 'pending': 'done';
      final updated   = await repository.updateTaskStatus(id, UpdateTask(status: newStatus,));
      emit(TaskDetailLoaded(updated));
    } catch (e) {
      emit(TaskDetailLoaded(current.task)); // revert on error
      emit(TaskDetailError(ErrorConst.parse(e)));
    }
  }
}