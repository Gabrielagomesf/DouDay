import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/missions_provider.dart';
import '../models/mission_model.dart';

class MissionsScreen extends ConsumerWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(missionsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Missões'),
      ),
      body: SafeArea(
        child: async.when(
          data: (data) {
            return RefreshIndicator(
              onRefresh: () => ref.read(missionsProvider.notifier).refresh(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const maxContentWidth = 600.0;
                  final horizontalInset =
                      constraints.maxWidth > maxContentWidth ? (constraints.maxWidth - maxContentWidth) / 2 : 0.0;

                  return ListView(
                    padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 16),
                    children: [
                      const Text('Missão do dia', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...data.daily.map((m) => _MissionTile(mission: m)),
                      const SizedBox(height: 16),
                      const Text('Missões da semana', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...data.weekly.map((m) => _MissionTile(mission: m)),
                    ],
                  );
                },
              ),
            );
          },
          error: (e, _) => Center(child: Text('Erro: $e')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _MissionTile extends ConsumerWidget {
  final MissionModel mission;
  const _MissionTile({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = mission.status == 'completed';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => ref.read(missionsProvider.notifier).toggle(mission),
        child: Row(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? AppTheme.success : AppTheme.textTertiary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mission.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  decoration: done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Text('+${mission.points}', style: const TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

