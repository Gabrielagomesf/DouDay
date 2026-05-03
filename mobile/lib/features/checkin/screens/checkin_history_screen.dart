import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_title.dart';
import '../checkin_mood_utils.dart';
import '../models/checkin_model.dart';
import '../providers/checkin_provider.dart';

class CheckinHistoryScreen extends ConsumerWidget {
  const CheckinHistoryScreen({super.key});

  static List<String> _lastNDayKeys(int n) {
    final out = <String>[];
    final today = DateTime.now();
    for (var i = n - 1; i >= 0; i--) {
      final d = DateTime(today.year, today.month, today.day).subtract(Duration(days: i));
      out.add(
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
      );
    }
    return out;
  }

  static double? _avgForDays(List<CheckinModel> items, Iterable<String> dayKeys, {required String? userId, bool? mine}) {
    final keys = dayKeys.toSet();
    final filtered = items.where((c) {
      if (!keys.contains(c.dayKey)) return false;
      if (mine == null) return true;
      if (mine) return c.userId == userId;
      return c.userId != userId;
    });
    if (filtered.isEmpty) return null;
    final sum = filtered.fold<double>(0, (s, c) => s + moodToScore(c.mood));
    return sum / filtered.length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(checkinHistoryProvider);
    final uid = ref.watch(authServiceProvider).currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de check-ins'),
      ),
      body: SafeArea(
        child: historyAsync.when(
          data: (items) {
            final weekKeys = _lastNDayKeys(7);
            final monthPrefix = DateFormat('yyyy-MM').format(DateTime.now());
            final monthItems = items.where((c) => c.dayKey.startsWith(monthPrefix)).toList();

            final weekMine = uid != null ? _avgForDays(items, weekKeys, userId: uid, mine: true) : null;
            final weekPartner = uid != null ? _avgForDays(items, weekKeys, userId: uid, mine: false) : null;
            final weekCouple = _avgForDays(items, weekKeys, userId: uid, mine: null);

            double? monthAvg(List<CheckinModel> src, {required bool? mine}) {
              if (uid == null) return null;
              final filtered = mine == null
                  ? src
                  : mine
                      ? src.where((c) => c.userId == uid)
                      : src.where((c) => c.userId != uid);
              if (filtered.isEmpty) return null;
              final sum = filtered.fold<double>(0, (s, c) => s + moodToScore(c.mood));
              return sum / filtered.length;
            }

            final monthMine = monthAvg(monthItems, mine: true);
            final monthPartner = monthAvg(monthItems, mine: false);
            final monthCouple = monthAvg(monthItems, mine: null);

            final spots = <BarChartGroupData>[];
            for (var i = 0; i < weekKeys.length; i++) {
              final key = weekKeys[i];
              final dayItems = items.where((c) => c.dayKey == key).toList();
              final avg = dayItems.isEmpty
                  ? 0.0
                  : dayItems.fold<double>(0, (s, c) => s + moodToScore(c.mood)) / dayItems.length;
              spots.add(
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: avg == 0 ? 0.05 : avg,
                      width: 10,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => ref.read(checkinHistoryProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const AppSectionTitle(
                    title: 'Resumo emocional',
                    subtitle: 'Médias da semana e do mês com comparativo.',
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Esta semana', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _Metric(
                              label: 'Meu humor',
                              value: weekMine != null ? scoreToShortLabel(weekMine) : '—',
                            ),
                            _Metric(
                              label: 'Parceiro',
                              value: weekPartner != null ? scoreToShortLabel(weekPartner) : '—',
                            ),
                            _Metric(
                              label: 'Média do casal',
                              value: weekCouple != null ? scoreToShortLabel(weekCouple) : '—',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mês atual', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _Metric(
                              label: 'Meu humor',
                              value: monthMine != null ? scoreToShortLabel(monthMine) : '—',
                            ),
                            _Metric(
                              label: 'Parceiro',
                              value: monthPartner != null ? scoreToShortLabel(monthPartner) : '—',
                            ),
                            _Metric(
                              label: 'Média do casal',
                              value: monthCouple != null ? scoreToShortLabel(monthCouple) : '—',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gráfico dos últimos 7 dias', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        const Text(
                          'Média do humor do casal por dia (escala 1–5).',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              maxY: 5,
                              gridData: FlGridData(show: true, drawVerticalLine: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    getTitlesWidget: (value, meta) {
                                      final i = value.toInt();
                                      if (i < 0 || i >= weekKeys.length) return const SizedBox.shrink();
                                      final parts = weekKeys[i].split('-');
                                      final d = int.tryParse(parts[2]) ?? i;
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text('$d', style: const TextStyle(fontSize: 10)),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 1,
                                    getTitlesWidget: (v, _) => Text(
                                      v.toInt().toString(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: spots,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const AppSectionTitle(title: 'Últimos registros'),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    const AppCard(
                      child: Text('Nenhum check-in ainda', style: TextStyle(color: AppTheme.textSecondary)),
                    )
                  else
                    ...items.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CheckinTile(item: e, currentUserId: uid),
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
  final String? currentUserId;

  const _CheckinTile({required this.item, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final who = currentUserId != null && item.userId == currentUserId ? 'Você' : 'Parceiro';
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.dayKey} · $who',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(moodLabelPt(item.mood), style: const TextStyle(color: AppTheme.textSecondary)),
          if (item.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(item.comment, style: const TextStyle(color: AppTheme.textPrimary)),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}
