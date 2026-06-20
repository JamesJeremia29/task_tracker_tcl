import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker_tcl/core/data/source/local_source.dart';
import 'package:task_tracker_tcl/core/data/source/remote_source.dart';
import 'package:task_tracker_tcl/core/data/repository/task_repo_prod.dart';
import 'package:task_tracker_tcl/application/app_theme.dart';
import 'package:task_tracker_tcl/utils/constant/prompt_const.dart';
import 'package:task_tracker_tcl/core/presenter/view/task_list/task_list_page.dart';
import 'package:task_tracker_tcl/utils/constant/supabase_const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:     SupabaseConst.supabaseUrl,
    anonKey: SupabaseConst.supabaseAnonKey,
  );

  final prefs = await SharedPreferences.getInstance();

  final repository = TaskRepoProd(
    remote: TaskRemoteDatasource(Supabase.instance.client),
    local:  TaskLocalDatasource(prefs),
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TaskRepoProd repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:        PromptConst.appName,
      debugShowCheckedModeBanner: false,
      theme:        AppTheme.light,
      darkTheme:    AppTheme.dark,
      themeMode:    ThemeMode.system,
      home:         TaskListPage(repository: repository),
    );
  }
}