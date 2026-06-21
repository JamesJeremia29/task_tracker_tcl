import 'package:task_tracker_tcl/core/data/model/post_task.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks({int page = 0});
  Future<int>             getTasksCount(); 
  Future<int> getTasksCountByStatus(String status);
  Future<void>            cacheCounts({  
    required int total,
    required int done,
    required int pending,
  });
  Future<TaskModel>       getTaskById(String id);
  Future<TaskModel>       createTask(PostTask request);
  Future<TaskModel>       updateTaskStatus(String id, UpdateTask request);
  Future<Map<String, int>> getCachedCounts();
}