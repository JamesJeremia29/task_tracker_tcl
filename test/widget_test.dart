import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker_tcl/core/data/model/post_task.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/core/presenter/view/task_list/task_list_page.dart';
import 'package:task_tracker_tcl/application/app_theme.dart';
import 'dart:async';

// Mock repository
class MockTaskRepository extends Mock implements TaskRepository {}

// Fake models for mocktail fallback
class FakeCreateTaskRequest extends Fake implements PostTask {}

class FakeUpdateTaskRequest extends Fake implements UpdateTask {}

void main() {
  late MockTaskRepository mockRepository;

  // Sample tasks
  final tTask = TaskModel(
    id: '1',
    title: 'Clean the room',
    description: 'Vacuum and mop',
    status: 'pending',
    createdAt: DateTime(2026, 6, 20),
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateTaskRequest());
    registerFallbackValue(FakeUpdateTaskRequest());
  });

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  // Helper to wrap widget with MaterialApp + theme
  Widget buildApp(MockTaskRepository repo) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: TaskListPage(repository: repo),
    );
  }

  group('TaskListPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      // Use Completer so we control when the future resolves
      final completer = Completer<List<TaskModel>>();

      when(() => mockRepository.getTasks())
          .thenAnswer((_) async => completer.future);

      await tester.pumpWidget(buildApp(mockRepository));
      await tester.pump(); // single frame — still loading

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future to avoid pending timer warning
      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('shows empty state when no tasks', (tester) async {
      when(() => mockRepository.getTasks()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildApp(mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('No tasks yet'), findsOneWidget);
    });

    testWidgets('shows task list when tasks exist', (tester) async {
      when(() => mockRepository.getTasks()).thenAnswer((_) async => [tTask]);

      await tester.pumpWidget(buildApp(mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('Clean the room'), findsOneWidget);
      expect(find.text('Vacuum and mop'), findsOneWidget);
    });

    testWidgets('shows error widget on failure', (tester) async {
      when(() => mockRepository.getTasks())
          .thenThrow(Exception('Network error'));

      await tester.pumpWidget(buildApp(mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('Oops!'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('shows summary bar with correct counts', (tester) async {
      final tasks = [
        tTask,
        tTask.copyWith(id: '2', status: 'done'),
      ];
      when(() => mockRepository.getTasks()).thenAnswer((_) async => tasks);

      await tester.pumpWidget(buildApp(mockRepository));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget); // total
      expect(find.text('1'), findsWidgets); // done + pending each = 1
    });
  });
}
