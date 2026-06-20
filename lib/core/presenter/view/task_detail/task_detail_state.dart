import 'package:task_tracker_tcl/core/data/model/task_model.dart';

abstract class TaskDetailState {}

class TaskDetailInitial  extends TaskDetailState {}
class TaskDetailLoading  extends TaskDetailState {}
class TaskDetailUpdating extends TaskDetailState { final TaskModel task; TaskDetailUpdating(this.task); }
class TaskDetailLoaded   extends TaskDetailState { final TaskModel task; TaskDetailLoaded(this.task); }
class TaskDetailError    extends TaskDetailState { final String message; TaskDetailError(this.message); }