import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';
import '../services/tasks_service.dart';

final tasksServiceProvider = Provider<TasksService>((ref) {
  return TasksService();
});

class TasksQueryState {
  final String? filter; // today|overdue|completed|null
  final String? assignee; // me|partner|both|null
  const TasksQueryState({this.filter, this.assignee});

  TasksQueryState copyWith({String? filter, String? assignee}) {
    return TasksQueryState(
      filter: filter,
      assignee: assignee,
    );
  }
}

final tasksQueryProvider = NotifierProvider<TasksQueryNotifier, TasksQueryState>(
  TasksQueryNotifier.new,
);

class TasksQueryNotifier extends Notifier<TasksQueryState> {
  @override
  TasksQueryState build() => const TasksQueryState();

  void setFilter(String? filter) => state = state.copyWith(filter: filter);
  void setAssignee(String? assignee) => state = state.copyWith(assignee: assignee);
}

final tasksListProvider = AsyncNotifierProvider<TasksListNotifier, List<TaskModel>>(
  TasksListNotifier.new,
);

class TasksListNotifier extends AsyncNotifier<List<TaskModel>> {
  @override
  Future<List<TaskModel>> build() async {
    final query = ref.watch(tasksQueryProvider);
    return ref.read(tasksServiceProvider).list(filter: query.filter, assignee: query.assignee);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> toggleComplete(TaskModel task) async {
    final nextStatus = task.status == 'completed' ? 'pending' : 'completed';
    await ref.read(tasksServiceProvider).setStatus(task.id, nextStatus);
    await refresh();
  }

  Future<void> delete(TaskModel task) async {
    await ref.read(tasksServiceProvider).remove(task.id);
    await refresh();
  }
}

