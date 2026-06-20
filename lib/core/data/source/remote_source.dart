import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker_tcl/core/data/model/post_task.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';

abstract class RemoteSource {
  Future<List<TaskModel>> getTasks({int page = 0});
  Future<int> getTasksCount();
  Future<int> getTasksCountByStatus(String status);
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> createTask(PostTask request);
  Future<TaskModel> updateTaskStatus(String id, UpdateTask request);
}

class TaskRemoteDatasource implements RemoteSource {
  final SupabaseClient _client;
  static const _table = 'tasks';

  TaskRemoteDatasource(this._client);

  static const int _pageSize = 10;

  @override
  Future<List<TaskModel>> getTasks({int page = 0}) async {
    try {
      final from = page * _pageSize;
      final to = from + _pageSize - 1;

      final res = await _client
          .from(_table)
          .select()
          .order('created_at', ascending: false)
          .range(from, to); // ← pagination here

      return (res as List).map((e) => TaskModel.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Remote: Failed to fetch tasks — ${e.message}');
    }
  }

  @override
  Future<int> getTasksCount() async {
    try {
      final res = await _client.from(_table).select().count(CountOption.exact);
      return res.count;
    } on PostgrestException catch (e) {
      throw Exception('Remote: Failed to count tasks — ${e.message}');
    }
  }

  @override
  Future<int> getTasksCountByStatus(String status) async {
    try {
      final res = await _client
          .from(_table)
          .select()
          .eq('status', status)
          .count(CountOption.exact);
      return res.count;
    } on PostgrestException catch (e) {
      throw Exception('Remote: Failed to count tasks by status — ${e.message}');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final res = await _client.from(_table).select().eq('id', id).single();
      return TaskModel.fromJson(res);
    } on PostgrestException catch (e) {
      throw Exception('Remote: Failed to fetch task — ${e.message}');
    }
  }

  @override
  Future<TaskModel> createTask(PostTask request) async {
    try {
      final res =
          await _client.from(_table).insert(request.toJson()).select().single();
      return TaskModel.fromJson(res);
    } on PostgrestException catch (e) {
      throw Exception('Remote: Failed to create task — ${e.message}');
    }
  }

  @override
  Future<TaskModel> updateTaskStatus(String id, UpdateTask request) async {
    try {
      final res = await _client
          .from(_table)
          .update(request.toJson())
          .eq('id', id)
          .select()
          .single();
      return TaskModel.fromJson(res);
    } on PostgrestException catch (e) {
      throw Exception('Remote: Failed to update task — ${e.message}');
    }
  }
}
