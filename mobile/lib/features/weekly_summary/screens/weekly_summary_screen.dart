import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/api_client.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_title.dart';

final weeklySummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ApiClient();
  final res = await api.get('/weekly-summary');
  final data = res.data;
  final summary = data is Map<String, dynamic> ? data['summary'] : null;
  if (summary is Map<String, dynamic>) return summary;
  return {};
});

class WeeklySummaryScreen extends ConsumerWidget {
  const WeeklySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(weeklySummaryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo semanal'),
      ),
      body: SafeArea(
        child: async.when(
          data: (s) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const AppSectionTitle(
                  title: 'Período da semana',
                  subtitle: 'Comparativo com a semana anterior',
                ),
                const SizedBox(height: 12),
                AppCard(
                  child: Column(
                    children: [
                      _Row(label: 'Tarefas concluídas', value: '${s['tasksDone'] ?? 0}'),
                      _Row(label: 'Contas pagas', value: '${s['billsPaid'] ?? 0}'),
                      _Row(label: 'Eventos realizados', value: '${s['events'] ?? 0}'),
                      _Row(label: 'Check-ins feitos', value: '${s['checkins'] ?? 0}'),
                      _Row(label: 'Missões concluídas', value: '${s['missionsDone'] ?? 0}'),
                      _Row(label: 'Metas avançadas', value: '${s['goalsProgress'] ?? '—'}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Text(
                    (s['message'] ?? 'Vocês tiveram uma semana bem organizada.').toString(),
                    style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                const AppCard(
                  child: Text(
                    'Equilíbrio de responsabilidades: acompanhe tarefas concluídas por cada um para manter a divisão justa ao longo da semana.',
                    style: TextStyle(color: AppTheme.textSecondary, height: 1.45),
                  ),
                ),
              ],
            );
          },
          error: (e, _) => Center(child: Text('Erro: $e')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppTheme.textSecondary))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

