import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/utils/constant/error_const.dart';
import 'add_task_state.dart';
import 'package:task_tracker_tcl/core/data/model/post_task.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final TaskRepository repository;

  AddTaskCubit(this.repository) : super(AddTaskInitial());

  Future<void> addTask({
    required String title,
    required String description,
  }) async {
    emit(AddTaskLoading());
    try {
      await repository.createTask(
        PostTask(
          title:       title.trim(),
          description: description.trim(),
        ),
      );
      emit(AddTaskSuccess());
    } catch (e) {
      emit(AddTaskError(ErrorConst.parse(e)));
    }
  }
}