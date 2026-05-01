import '../../../core/utils/api_client.dart';
import '../models/checkin_model.dart';

class CheckinService {
  final ApiClient _api = ApiClient();

  Map<String, dynamic> _normalizeId(Map<String, dynamic> json) {
    if (json.containsKey('id')) return json;
    if (json.containsKey('_id')) return {...json, 'id': json['_id']};
    return json;
  }

  Future<CheckinModel> submit({required String mood, String? comment}) async {
    final res = await _api.post('/checkins', data: {'mood': mood, 'comment': comment ?? ''});
    final data = res.data;
    final json = data is Map<String, dynamic> ? data['checkin'] : null;
    if (json is Map<String, dynamic>) return CheckinModel.fromJson(_normalizeId(json));
    throw Exception('Resposta inválida ao enviar check-in');
  }

  Future<List<CheckinModel>> list({String? from, String? to}) async {
    final res = await _api.get('/checkins', queryParameters: {if (from != null) 'from': from, if (to != null) 'to': to});
    final data = res.data;
    final arr = data is Map<String, dynamic> ? data['checkins'] : null;
    if (arr is List) {
      return arr.whereType<Map>().map((e) => CheckinModel.fromJson(_normalizeId(e.cast<String, dynamic>()))).toList();
    }
    return [];
  }
}

