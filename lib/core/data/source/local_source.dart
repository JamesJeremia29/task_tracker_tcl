import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';

abstract class LocalSource {
  Future<List<TaskModel>> getCachedTasks();
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<void> clearCache();
  Future<bool> hasCachedTasks();
  Future<void> cacheCounts({
    required int total,
    required int done,
    required int pending,
  });
  Future<Map<String, int>> getCachedCounts();
}

class TaskLocalDatasource implements LocalSource {
  static const _cacheKey = 'cached_tasks';
  static const _cacheTimeKey = 'cached_tasks_time';
  static const _cacheDuration = Duration(minutes: 10);

  final SharedPreferences _prefs;

  TaskLocalDatasource(this._prefs);

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    try {
      final raw = _prefs.getString(_cacheKey);
      if (raw == null) return [];

      final list = jsonDecode(raw) as List;
      return list.map((e) => TaskModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await _prefs.setString(_cacheKey, encoded);
    await _prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  @override
  Future<bool> hasCachedTasks() async {
    final raw = _prefs.getString(_cacheKey);
    final timeRaw = _prefs.getString(_cacheTimeKey);
    if (raw == null || timeRaw == null) return false;

    final cachedAt = DateTime.tryParse(timeRaw);
    if (cachedAt == null) return false;

    //Expire cache after 10 minutes
    final isExpired = DateTime.now().difference(cachedAt) > _cacheDuration;
    if (isExpired) {
      await clearCache();
      return false;
    }

    return true;
  }

  static const _countKey = 'cached_counts';

  @override
  Future<void> cacheCounts({
    required int total,
    required int done,
    required int pending,
  }) async {
    final encoded = jsonEncode({
      'total': total,
      'done': done,
      'pending': pending,
    });
    await _prefs.setString(_countKey, encoded);
  }

  @override
  Future<Map<String, int>> getCachedCounts() async {
    try {
      final raw = _prefs.getString(_countKey);
      if (raw == null) return {'total': 0, 'done': 0, 'pending': 0};
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return {
        'total': map['total'] as int,
        'done': map['done'] as int,
        'pending': map['pending'] as int,
      };
    } catch (_) {
      return {'total': 0, 'done': 0, 'pending': 0};
    }
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_cacheTimeKey);
    await _prefs.remove(_countKey);
  }
}
