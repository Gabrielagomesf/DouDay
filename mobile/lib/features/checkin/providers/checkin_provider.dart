import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/checkin_model.dart';
import '../services/checkin_service.dart';

final checkinServiceProvider = Provider<CheckinService>((ref) => CheckinService());

final todayCheckinProvider = AsyncNotifierProvider<TodayCheckinNotifier, CheckinModel?>(
  TodayCheckinNotifier.new,
);

class TodayCheckinNotifier extends AsyncNotifier<CheckinModel?> {
  @override
  Future<CheckinModel?> build() async {
    // Load last 30 days and pick today; keeps backend simple
    final to = DateTime.now().toIso8601String().substring(0, 10);
    final from = DateTime.now().subtract(const Duration(days: 30)).toIso8601String().substring(0, 10);
    final list = await ref.read(checkinServiceProvider).list(from: from, to: to);
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return list.where((c) => c.dayKey == today).cast<CheckinModel?>().firstWhere((c) => true, orElse: () => null);
  }

  Future<void> submit({required String mood, String? comment}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final c = await ref.read(checkinServiceProvider).submit(mood: mood, comment: comment);
      return c;
    });
  }
}

final checkinHistoryProvider = AsyncNotifierProvider<CheckinHistoryNotifier, List<CheckinModel>>(
  CheckinHistoryNotifier.new,
);

class CheckinHistoryNotifier extends AsyncNotifier<List<CheckinModel>> {
  @override
  Future<List<CheckinModel>> build() async {
    final to = DateTime.now().toIso8601String().substring(0, 10);
    final from = DateTime.now().subtract(const Duration(days: 90)).toIso8601String().substring(0, 10);
    return ref.read(checkinServiceProvider).list(from: from, to: to);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

