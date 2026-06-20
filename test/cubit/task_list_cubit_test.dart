import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker_tcl/core/data/model/post_task.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/core/presenter/view/task_list/task_list_cubit.dart';
import 'package:task_tracker_tcl/core/presenter/view/task_list/task_list_state.dart';

class MockTaskRepository extends Mock implements TaskRepository {}
class FakeCreateTaskRequest extends Fake implements PostTask {}
class FakeUpdateTaskRequest extends Fake implements UpdateTask {}

void main() {
  late MockTaskRepository mockRepository;

  final tTask = TaskModel(
    id:          '1',
    title:       'Test Task',
    description: 'Test Desc',
    status:      'pending',
    createdAt:   DateTime(2026, 6, 20),
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateTaskRequest());
    registerFallbackValue(FakeUpdateTaskRequest());
  });

  setUp(() => mockRepository = MockTaskRepository());

  group('TaskListCubit', () {
    blocTest<TaskListCubit, TaskListState>(
      'emits [Loading, Loaded] when getTasks succeeds',
      build: () {
        when(() => mockRepository.getTasks())
            .thenAnswer((_) async => [tTask]);
        return TaskListCubit(mockRepository);
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        isA<TaskListLoading>(),
        isA<TaskListLoaded>(),
      ],
    );

    blocTest<TaskListCubit, TaskListState>(
      'emits [Loading, Empty] when task list is empty',
      build: () {
        when(() => mockRepository.getTasks())
            .thenAnswer((_) async => []);
        return TaskListCubit(mockRepository);
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        isA<TaskListLoading>(),
        isA<TaskListEmpty>(),
      ],
    );

    blocTest<TaskListCubit, TaskListState>(
      'emits [Loading, Error] when getTasks throws',
      build: () {
        when(() => mockRepository.getTasks())
            .thenThrow(Exception('Server error'));
        return TaskListCubit(mockRepository);
      },
      act: (cubit) => cubit.loadTasks(),
      expect: () => [
        isA<TaskListLoading>(),
        isA<TaskListError>(),
      ],
    );

    blocTest<TaskListCubit, TaskListState>(
      'emits [Loading, Loaded] after toggleStatus succeeds',
      build: () {
        when(() => mockRepository.getTasks())
            .thenAnswer((_) async => [tTask]);
        when(() => mockRepository.updateTaskStatus(
              any(),
              any(),
            )).thenAnswer((_) async => tTask.copyWith(status: 'done'));
        return TaskListCubit(mockRepository);
      },
      act: (cubit) => cubit.toggleStatus('1', 'pending'),
      expect: () => [
        isA<TaskListLoading>(),
        isA<TaskListLoaded>(),
      ],
    );

    test('TaskListLoaded computes doneCount and pendingCount correctly', () {
      final tasks = [
        tTask,
        tTask.copyWith(id: '2', status: 'done'),
        tTask.copyWith(id: '3', status: 'done'),
      ];
      final state = TaskListLoaded(tasks);

      expect(state.doneCount,    2);
      expect(state.pendingCount, 1);
    });
  });
}