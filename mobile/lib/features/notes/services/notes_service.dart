import '../../../core/utils/api_client.dart';
import '../models/note_model.dart';

class NotesService {
  final ApiClient _api = ApiClient();

  Map<String, dynamic> _normalizeId(Map<String, dynamic> json) {
    if (json.containsKey('id')) return json;
    if (json.containsKey('_id')) return {...json, 'id': json['_id']};
    return json;
  }

  Future<List<NoteModel>> list({String? q, bool? pinned}) async {
    final res = await _api.get('/notes', queryParameters: {
      if (q != null && q.isNotEmpty) 'q': q,
      if (pinned == true) 'pinned': 'true',
    });
    final data = res.data;
    final arr = data is Map<String, dynamic> ? data['notes'] : null;
    if (arr is List) {
      return arr.whereType<Map>().map((e) => NoteModel.fromJson(_normalizeId(e.cast<String, dynamic>()))).toList();
    }
    return [];
  }

  Future<NoteModel> create(Map<String, dynamic> payload) async {
    final res = await _api.post('/notes', data: payload);
    final data = res.data;
    final json = data is Map<String, dynamic> ? data['note'] : null;
    if (json is Map<String, dynamic>) return NoteModel.fromJson(_normalizeId(json));
    throw Exception('Resposta inválida ao criar nota');
  }

  Future<NoteModel> update(String id, Map<String, dynamic> payload) async {
    final res = await _api.put('/notes/$id', data: payload);
    final data = res.data;
    final json = data is Map<String, dynamic> ? data['note'] : null;
    if (json is Map<String, dynamic>) return NoteModel.fromJson(_normalizeId(json));
    throw Exception('Resposta inválida ao atualizar nota');
  }

  Future<NoteModel> pin(String id, bool isPinned) async {
    final res = await _api.patch('/notes/$id/pin', data: {'isPinned': isPinned});
    final data = res.data;
    final json = data is Map<String, dynamic> ? data['note'] : null;
    if (json is Map<String, dynamic>) return NoteModel.fromJson(_normalizeId(json));
    throw Exception('Resposta inválida ao fixar nota');
  }

  Future<void> remove(String id) async {
    await _api.delete('/notes/$id');
  }
}

