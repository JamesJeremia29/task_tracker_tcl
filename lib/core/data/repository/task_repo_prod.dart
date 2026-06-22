import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_tracker_tcl/core/data/source/local_source.dart';
import 'package:task_tracker_tcl/core/data/source/remote_source.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/core/data/model/post_task.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';

class TaskRepoProd implements TaskRepository {
  final RemoteSource remote;
  final LocalSource local;
  final Connectivity _connectivity;

  TaskRepoProd({
    required this.remote,
    required this.local,
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  Future<bool> get _isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  @override
  Future<List<TaskModel>> getTasks({int page = 0}) async {
    if (await _isOnline) {
      try {
        final tasks = await remote.getTasks(page: page);
        if (page == 0) await local.cacheTasks(tasks);
        return tasks;
      } catch (e) {
        if (page == 0) {
          final hasCached = await local.hasCachedTasks();
          if (hasCached) return local.getCachedTasks();
        }
        rethrow;
      }
    } else {
      if (page == 0) {
        final hasCached = await local.hasCachedTasks();
        if (hasCached) return local.getCachedTasks();
      }
      throw Exception('No internet connection and no cached data available.');
    }
  }

  @override
  Future<int> getTasksCount() async {
    if (await _isOnline) {
      return remote.getTasksCount();
    }
    final counts = await local.getCachedCounts();
    return counts['total'] ?? 0;
  }

  @override
  Future<int> getTasksCountByStatus(String status) async {
    if (await _isOnline) {
      return remote.getTasksCountByStatus(status);
    }
    final counts = await local.getCachedCounts();
    return counts[status] ?? 0;
  }

  @override
  Future<void> cacheCounts({
    required int total,
    required int done,
    required int pending,
  }) async {
    await local.cacheCounts(
      total: total,
      done: done,
      pending: pending,
    );
  }

  @override
  Future<Map<String, int>> getCachedCounts() async {
    return local.getCachedCounts();
  }

  @override
  Future<TaskModel> getTaskById(String id) {
    return remote.getTaskById(id);
  }

  @override
  Future<TaskModel> createTask(PostTask request) async {
    if (!await _isOnline) {
      throw Exception('No internet connection. Cannot add task.');
    }
    final task = await remote.createTask(request);
    await local.clearCache();
    return task;
  }

  @override
  Future<TaskModel> updateTaskStatus(String id, UpdateTask request) async {
    if (!await _isOnline) {
      throw Exception('No internet connection. Cannot update task.');
    }
    final task = await remote.updateTaskStatus(id, request);
    await local.clearCache();
    return task;
  }
}
