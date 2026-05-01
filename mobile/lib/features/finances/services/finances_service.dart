import '../../../core/utils/api_client.dart';
import '../models/finance_bill_model.dart';

class FinancesService {
  final ApiClient _api = ApiClient();

  Map<String, dynamic> _normalizeId(Map<String, dynamic> json) {
    if (json.containsKey('id')) return json;
    if (json.containsKey('_id')) return {...json, 'id': json['_id']};
    return json;
  }

  Future<Map<String, dynamic>> summary({String? month}) async {
    final res = await _api.get('/finances/summary', queryParameters: {if (month != null) 'month': month});
    final data = res.data;
    final sum = data is Map<String, dynamic> ? data['summary'] : null;
    if (sum is Map<String, dynamic>) return sum;
    return {};
  }

  Future<List<FinanceBillModel>> list({String? status, String? category}) async {
    final res = await _api.get('/finances', queryParameters: {
      if (status != null) 'status': status,
      if (category != null) 'category': category,
    });
    final data = res.data;
    final billsJson = data is Map<String, dynamic> ? data['bills'] : null;
    if (billsJson is List) {
      return billsJson
          .whereType<Map>()
          .map((e) => FinanceBillModel.fromJson(_normalizeId(e.cast<String, dynamic>())))
          .toList();
    }
    return [];
  }

  Future<FinanceBillModel> create(Map<String, dynamic> payload) async {
    final res = await _api.post('/finances', data: payload);
    final data = res.data;
    final billJson = data is Map<String, dynamic> ? data['bill'] : null;
    if (billJson is Map<String, dynamic>) return FinanceBillModel.fromJson(_normalizeId(billJson));
    throw Exception('Resposta inválida ao criar conta');
  }

  Future<FinanceBillModel> update(String id, Map<String, dynamic> payload) async {
    final res = await _api.put('/finances/$id', data: payload);
    final data = res.data;
    final billJson = data is Map<String, dynamic> ? data['bill'] : null;
    if (billJson is Map<String, dynamic>) return FinanceBillModel.fromJson(_normalizeId(billJson));
    throw Exception('Resposta inválida ao atualizar conta');
  }

  Future<FinanceBillModel> setStatus(String id, String status) async {
    final res = await _api.patch('/finances/$id/status', data: {'status': status});
    final data = res.data;
    final billJson = data is Map<String, dynamic> ? data['bill'] : null;
    if (billJson is Map<String, dynamic>) return FinanceBillModel.fromJson(_normalizeId(billJson));
    throw Exception('Resposta inválida ao atualizar status');
  }

  Future<void> remove(String id) async {
    await _api.delete('/finances/$id');
  }
}

