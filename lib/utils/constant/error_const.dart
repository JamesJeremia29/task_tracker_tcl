class ErrorConst {
  ErrorConst._();

  // Generic
  static const String unknown        = 'Something went wrong. Please try again.';
  static const String noInternet     = 'No internet connection. Check your network.';
  static const String timeout        = 'Request timed out. Please try again.';

  // Task-specific
  static const String loadTasksFailed   = 'Failed to load tasks.';
  static const String addTaskFailed     = 'Failed to add task. Please try again.';
  static const String updateTaskFailed  = 'Failed to update task status.';
  static const String taskNotFound      = 'Task not found.';

  // Supabase / API
  static const String serverError      = 'Server error. Please try again later.';
  static const String unauthorized     = 'Unauthorized access.';

  static String parse(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('socket') || msg.contains('network'))  return noInternet;
    if (msg.contains('timeout'))                             return timeout;
    if (msg.contains('401') || msg.contains('unauthorized')) return unauthorized;
    if (msg.contains('500') || msg.contains('server'))       return serverError;
    if (msg.contains('not found') || msg.contains('404'))    return taskNotFound;
    return unknown;
  }
}