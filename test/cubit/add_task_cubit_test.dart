import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_tracker_tcl/core/data/model/post_task.dart';
import 'package:task_tracker_tcl/core/data/model/task_model.dart';
import 'package:task_tracker_tcl/core/data/model/update_task.dart';
import 'package:task_tracker_tcl/core/feature/task_repo_feat.dart';
import 'package:task_tracker_tcl/core/presenter/view/add_task/add_task_cubit.dart';
import 'package:task_tracker_tcl/core/presenter/view/add_task/add_task_state.dart';

class MockTaskRepository extends Mock implements TaskRepository {}
class FakeCreateTaskRequest extends Fake implements PostTask {}
class FakeUpdateTaskRequest extends Fake implements UpdateTask {}

void main() {
  late MockTaskRepository mockRepository;

  final tTask = TaskModel(
    id:          '1',
    title:       'New Task',
    description: 'Some description',
    status:      'pending',
    createdAt:   DateTime(2026, 6, 20),
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateTaskRequest());
    registerFallbackValue(FakeUpdateTaskRequest());
  });

  setUp(() => mockRepository = MockTaskRepository());

  group('AddTaskCubit', () {
    blocTest<AddTaskCubit, AddTaskState>(
      'emits [Loading, Success] when createTask succeeds',
      build: () {
        when(() => mockRepository.createTask(any()))
            .thenAnswer((_) async => tTask);
        return AddTaskCubit(mockRepository);
      },
      act: (cubit) => cubit.addTask(
        title:       'New Task',
        description: 'Some description',
      ),
      expect: () => [
        isA<AddTaskLoading>(),
        isA<AddTaskSuccess>(),
      ],
    );

    blocTest<AddTaskCubit, AddTaskState>(
      'emits [Loading, Error] when createTask throws',
      build: () {
        when(() => mockRepository.createTask(any()))
            .thenThrow(Exception('Failed'));
        return AddTaskCubit(mockRepository);
      },
      act: (cubit) => cubit.addTask(
        title:       'New Task',
        description: 'Some description',
      ),
      expect: () => [
        isA<AddTaskLoading>(),
        isA<AddTaskError>(),
      ],
    );
  });
}