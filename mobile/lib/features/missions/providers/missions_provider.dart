import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mission_model.dart';
import '../services/missions_service.dart';

final missionsServiceProvider = Provider<MissionsService>((ref) => MissionsService());

final missionsProvider = AsyncNotifierProvider<MissionsNotifier, ({List<MissionModel> daily, List<MissionModel> weekly})>(
  MissionsNotifier.new,
);

class MissionsNotifier extends AsyncNotifier<({List<MissionModel> daily, List<MissionModel> weekly})> {
  @override
  Future<({List<MissionModel> daily, List<MissionModel> weekly})> build() async {
    final (daily, weekly) = await ref.read(missionsServiceProvider).list();
    return (daily: daily, weekly: weekly);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }

  Future<void> toggle(MissionModel mission) async {
    final next = mission.status == 'completed' ? 'pending' : 'completed';
    await ref.read(missionsServiceProvider).setStatus(mission.id, next);
    await refresh();
  }
}

