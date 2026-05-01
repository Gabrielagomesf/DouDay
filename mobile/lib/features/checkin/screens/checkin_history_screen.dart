import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_title.dart';
import '../providers/checkin_provider.dart';
import '../models/checkin_model.dart';

class CheckinHistoryScreen extends ConsumerWidget {
  const CheckinHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(checkinHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de check-ins'),
      ),
      body: SafeArea(
        child: historyAsync.when(
          data: (items) {
            return RefreshIndicator(
              onRefresh: () => ref.read(checkinHistoryProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const AppSectionTitle(
                    title: 'Mês atual',
                    subtitle: 'Média do casal e evolução emocional',
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _Metric(label: 'Você', value: 'Bem'),
                        _Metric(label: 'Parceiro', value: 'Neutro'),
                        _Metric(label: 'Média', value: '7.8'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Gráfico emocional', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('Comparativo de humor do mês.', style: TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    const AppCard(
                      child: Text('Nenhum check-in ainda', style: TextStyle(color: AppTheme.textSecondary)),
                    )
                  else
                    ...items.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CheckinTile(item: e),
                        )),
                ],
              ),
            );
          },
          error: (e, _) => Center(
            child: ElevatedButton(
              onPressed: () => ref.read(checkinHistoryProvider.notifier).refresh(),
              child: const Text('Tentar novamente'),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _CheckinTile extends StatelessWidget {
  final CheckinModel item;
  const _CheckinTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.dayKey,
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(_moodLabel(item.mood), style: const TextStyle(color: AppTheme.textSecondary)),
          if (item.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(item.comment, style: const TextStyle(color: AppTheme.textPrimary)),
          ],
        ],
      ),
    );
  }

  String _moodLabel(String v) => switch (v) {
        'very_good' => 'Muito bem',
        'good' => 'Bem',
        'tired' => 'Cansado',
        'stressed' => 'Estressado',
        _ => 'Neutro',
      };
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

