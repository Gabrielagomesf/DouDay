import '../../../core/utils/api_client.dart';
import '../models/task_model.dart';

class TasksService {
  final ApiClient _api = ApiClient();

  Map<String, dynamic> _normalizeId(Map<String, dynamic> json) {
    if (json.containsKey('id')) return json;
    if (json.containsKey('_id')) {
      return {
        ...json,
        'id': json['_id'],
      };
    }
    return json;
  }

  Future<List<TaskModel>> list({
    String? filter,
    String? status,
    String? assignee,
  }) async {
    final res = await _api.get('/tasks', queryParameters: {
      if (filter != null) 'filter': filter,
      if (status != null) 'status': status,
      if (assignee != null) 'assignee': assignee,
    });
    final data = res.data;
    final tasksJson = data is Map<String, dynamic> ? data['tasks'] : null;
    if (tasksJson is List) {
      return tasksJson
          .whereType<Map>()
          .map((e) => TaskModel.fromJson(_normalizeId(e.cast<String, dynamic>())))
          .toList();
    }
    return [];
  }

  Future<TaskModel> create(Map<String, dynamic> payload) async {
    final res = await _api.post('/tasks', data: payload);
    final data = res.data;
    final taskJson = data is Map<String, dynamic> ? data['task'] : null;
    if (taskJson is Map<String, dynamic>) return TaskModel.fromJson(_normalizeId(taskJson));
    throw Exception('Resposta inválida ao criar tarefa');
  }

  Future<TaskModel> update(String id, Map<String, dynamic> payload) async {
    final res = await _api.put('/tasks/$id', data: payload);
    final data = res.data;
    final taskJson = data is Map<String, dynamic> ? data['task'] : null;
    if (taskJson is Map<String, dynamic>) return TaskModel.fromJson(_normalizeId(taskJson));
    throw Exception('Resposta inválida ao atualizar tarefa');
  }

  Future<TaskModel> setStatus(String id, String status) async {
    final res = await _api.patch('/tasks/$id/status', data: {'status': status});
    final data = res.data;
    final taskJson = data is Map<String, dynamic> ? data['task'] : null;
    if (taskJson is Map<String, dynamic>) return TaskModel.fromJson(_normalizeId(taskJson));
    throw Exception('Resposta inválida ao atualizar status');
  }

  Future<void> remove(String id) async {
    await _api.delete('/tasks/$id');
  }
}

