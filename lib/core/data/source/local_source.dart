import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';

abstract class LocalSource {
  Future<List<TaskModel>> getCachedTasks();
  Future<void>            cacheTasks(List<TaskModel> tasks);
  Future<void>            clearCache();
  Future<bool>            hasCachedTasks();
}

class TaskLocalDatasource implements LocalSource {
  static const _cacheKey        = 'cached_tasks';
  static const _cacheTimeKey    = 'cached_tasks_time';
  static const _cacheDuration   = Duration(minutes: 10);

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
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
    await _prefs.remove(_cacheTimeKey);
  }

  @override
  Future<bool> hasCachedTasks() async {
    final raw      = _prefs.getString(_cacheKey);
    final timeRaw  = _prefs.getString(_cacheTimeKey);
    if (raw == null || timeRaw == null) return false;

    final cachedAt = DateTime.tryParse(timeRaw);
    if (cachedAt == null) return false;

    // Expire cache after 10 minutes
    final isExpired = DateTime.now().difference(cachedAt) > _cacheDuration;
    if (isExpired) {
      await clearCache();
      return false;
    }

    return true;
  }
}