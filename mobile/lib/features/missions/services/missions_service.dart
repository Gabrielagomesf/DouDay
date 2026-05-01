import '../../../core/utils/api_client.dart';
import '../models/mission_model.dart';

class MissionsService {
  final ApiClient _api = ApiClient();

  Map<String, dynamic> _normalizeId(Map<String, dynamic> json) {
    if (json.containsKey('id')) return json;
    if (json.containsKey('_id')) return {...json, 'id': json['_id']};
    return json;
  }

  Future<(List<MissionModel> daily, List<MissionModel> weekly)> list() async {
    final res = await _api.get('/missions');
    final data = res.data;
    final dailyJson = data is Map<String, dynamic> ? data['daily'] : null;
    final weeklyJson = data is Map<String, dynamic> ? data['weekly'] : null;
    List<MissionModel> parse(dynamic v) {
      if (v is List) {
        return v.whereType<Map>().map((e) => MissionModel.fromJson(_normalizeId(e.cast<String, dynamic>()))).toList();
      }
      return [];
    }

    return (parse(dailyJson), parse(weeklyJson));
  }

  Future<MissionModel> setStatus(String id, String status) async {
    final res = await _api.patch('/missions/$id/status', data: {'status': status});
    final data = res.data;
    final json = data is Map<String, dynamic> ? data['mission'] : null;
    if (json is Map<String, dynamic>) return MissionModel.fromJson(_normalizeId(json));
    throw Exception('Resposta inválida ao atualizar missão');
  }
}

