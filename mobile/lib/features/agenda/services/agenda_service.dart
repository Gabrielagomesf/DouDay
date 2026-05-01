import '../../../core/utils/api_client.dart';
import '../models/agenda_event_model.dart';

class AgendaService {
  final ApiClient _api = ApiClient();

  Map<String, dynamic> _normalizeId(Map<String, dynamic> json) {
    if (json.containsKey('id')) return json;
    if (json.containsKey('_id')) return {...json, 'id': json['_id']};
    return json;
  }

  Future<List<AgendaEventModel>> list({
    DateTime? from,
    DateTime? to,
    String? participants,
  }) async {
    final res = await _api.get('/agenda', queryParameters: {
      if (from != null) 'from': from.toIso8601String(),
      if (to != null) 'to': to.toIso8601String(),
      if (participants != null) 'participants': participants,
    });
    final data = res.data;
    final eventsJson = data is Map<String, dynamic> ? data['events'] : null;
    if (eventsJson is List) {
      return eventsJson
          .whereType<Map>()
          .map((e) => AgendaEventModel.fromJson(_normalizeId(e.cast<String, dynamic>())))
          .toList();
    }
    return [];
  }

  Future<AgendaEventModel> create(Map<String, dynamic> payload) async {
    final res = await _api.post('/agenda', data: payload);
    final data = res.data;
    final eventJson = data is Map<String, dynamic> ? data['event'] : null;
    if (eventJson is Map<String, dynamic>) return AgendaEventModel.fromJson(_normalizeId(eventJson));
    throw Exception('Resposta inválida ao criar evento');
  }

  Future<AgendaEventModel> update(String id, Map<String, dynamic> payload) async {
    final res = await _api.put('/agenda/$id', data: payload);
    final data = res.data;
    final eventJson = data is Map<String, dynamic> ? data['event'] : null;
    if (eventJson is Map<String, dynamic>) return AgendaEventModel.fromJson(_normalizeId(eventJson));
    throw Exception('Resposta inválida ao atualizar evento');
  }

  Future<void> remove(String id) async {
    await _api.delete('/agenda/$id');
  }
}

