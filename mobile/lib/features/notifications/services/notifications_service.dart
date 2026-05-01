import '../../../core/utils/api_client.dart';
import '../models/app_notification_model.dart';

class NotificationsService {
  final ApiClient _api = ApiClient();

  Map<String, dynamic> _normalizeId(Map<String, dynamic> json) {
    if (json.containsKey('id')) return json;
    if (json.containsKey('_id')) return {...json, 'id': json['_id']};
    return json;
  }

  Future<List<AppNotificationModel>> list({String? type}) async {
    final res = await _api.get('/notifications', queryParameters: {if (type != null) 'type': type});
    final data = res.data;
    final arr = data is Map<String, dynamic> ? data['notifications'] : null;
    if (arr is List) {
      return arr.whereType<Map>().map((e) => AppNotificationModel.fromJson(_normalizeId(e.cast<String, dynamic>()))).toList();
    }
    return [];
  }

  Future<AppNotificationModel> markRead(String id, bool isRead) async {
    final res = await _api.patch('/notifications/$id/read', data: {'isRead': isRead});
    final data = res.data;
    final json = data is Map<String, dynamic> ? data['notification'] : null;
    if (json is Map<String, dynamic>) return AppNotificationModel.fromJson(_normalizeId(json));
    throw Exception('Resposta inválida');
  }

  Future<void> clearAll() async {
    await _api.delete('/notifications/clear');
  }
}

