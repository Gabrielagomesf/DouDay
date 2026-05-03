import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_generic_screen.dart';
import '../../../core/widgets/empty_state.dart';
import '../models/finance_bill_model.dart';
import '../providers/finances_provider.dart';

class FinancesScreen extends ConsumerWidget {
  const FinancesScreen({super.key});

  static Map<String, double> _aggregateByCategory(List<FinanceBillModel> bills) {
    final m = <String, double>{};
    for (final b in bills) {
      m.update(b.category, (v) => v + b.amount, ifAbsent: () => b.amount);
    }
    return m;
  }

  static String _categoryLabel(String key) {
    return switch (key) {
      'rent' => 'Aluguel',
      'internet' => 'Internet',
      'market' => 'Mercado',
      'leisure' => 'Lazer',
      'transport' => 'Transporte',
      'subscription' => 'Assinaturas',
      _ => 'Outros',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financesSummaryProvider);
    final allBillsAsync = ref.watch(financesAllBillsProvider);
    final billsAsync = ref.watch(billsProvider);
    final status = ref.watch(financesStatusFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Finanças'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/finances/new'),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: summaryAsync.when(
                data: (s) {
                  final raw = s['total'];
                  final totalNum = raw is num ? raw.toDouble() : double.tryParse('$raw') ?? 0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Saldo total do mês',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'R\$ ${totalNum.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryColor,
                            ),
                      ),
                      const SizedBox(height: 16),
                      allBillsAsync.when(
                        data: (all) {
                          final entrada =
                              all.where((b) => b.status == 'paid').fold<double>(0, (a, b) => a + b.amount);
                          final saida =
                              all.where((b) => b.status == 'pending').fold<double>(0, (a, b) => a + b.amount);
                          return Row(
                            children: [
                              Expanded(
                                child: _FluxoCard(
                                  title: 'Entradas',
                                  subtitle: 'Valores quitados',
                                  value: entrada,
                                  accent: AppTheme.success,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _FluxoCard(
                                  title: 'Saídas',
                                  subtitle: 'Contas a pagar',
                                  value: saida,
                                  accent: AppTheme.error,
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () => const SizedBox(height: 8),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
                error: (_, __) => const SizedBox.shrink(),
                loading: () => const LinearProgressIndicator(),
              ),
            ),
            billsAsync.when(
              data: (bills) {
                if (bills.isEmpty) {
                  return const Expanded(
                    child: EmptyState(
                      title: 'Nenhuma conta cadastrada',
                      body: 'Adicione uma conta para acompanhar os gastos do casal.',
                    ),
                  );
                }

                final byCat = _aggregateByCategory(bills);
                final entries = byCat.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                const palette = [
                  AppTheme.chartPurple,
                  AppTheme.chartPink,
                  AppTheme.chartBlueLight,
                  AppTheme.primarySecondary,
                  AppTheme.accentPink,
                ];

                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Por categoria',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 44,
                                    sections: List.generate(entries.length.clamp(0, 5), (i) {
                                      final e = entries[i];
                                      final sum = entries.fold<double>(0, (s, x) => s + x.value);
                                      final pct = sum > 0 ? (e.value / sum * 100) : 0.0;
                                      return PieChartSectionData(
                                        color: palette[i % palette.length],
                                        value: e.value,
                                        title: '${pct.toStringAsFixed(0)}%',
                                        radius: 52,
                                        titleStyle: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: List.generate(entries.length.clamp(0, 5), (i) {
                                  final e = entries[i];
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: palette[i % palette.length],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${_categoryLabel(e.key)} · R\$ ${e.value.toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('Todas'),
                              selected: status == null,
                              onSelected: (_) {
                                ref.read(financesStatusFilterProvider.notifier).set(null);
                                ref.read(billsProvider.notifier).refresh();
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Pendentes'),
                              selected: status == 'pending',
                              onSelected: (_) {
                                ref.read(financesStatusFilterProvider.notifier).set('pending');
                                ref.read(billsProvider.notifier).refresh();
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Pagas'),
                              selected: status == 'paid',
                              onSelected: (_) {
                                ref.read(financesStatusFilterProvider.notifier).set('paid');
                                ref.read(billsProvider.notifier).refresh();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await ref.read(billsProvider.notifier).refresh();
                            await ref.read(financesSummaryProvider.notifier).refresh();
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              const maxContentWidth = 600.0;
                              final horizontalInset = constraints.maxWidth > maxContentWidth
                                  ? (constraints.maxWidth - maxContentWidth) / 2
                                  : 0.0;

                              return ListView.separated(
                                padding: EdgeInsets.fromLTRB(16 + horizontalInset, 8, 16 + horizontalInset, 24),
                                itemCount: bills.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, i) => _BillTile(
                                  bill: bills[i],
                                  onTap: () => context.push('/finances/${bills[i].id}'),
                                  onTogglePaid: () => ref.read(billsProvider.notifier).togglePaid(bills[i]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (e, _) => Expanded(
                child: AppErrorGenericScreen(
                  title: 'Ops! Não conseguimos carregar suas finanças',
                  message: 'Tente novamente. Se persistir, verifique sua conexão.',
                  onRetry: () async {
                    await ref.read(billsProvider.notifier).refresh();
                    await ref.read(financesSummaryProvider.notifier).refresh();
                  },
                  backRoute: '/home',
                ),
              ),
              loading: () => const Expanded(child: Center(child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
    );
  }
}

class _FluxoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double value;
  final Color accent;
  const _FluxoCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 10),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _BillTile extends StatelessWidget {
  final FinanceBillModel bill;
  final VoidCallback onTap;
  final VoidCallback onTogglePaid;
  const _BillTile({required this.bill, required this.onTap, required this.onTogglePaid});

  @override
  Widget build(BuildContext context) {
    final isPaid = bill.status == 'paid';
    final due = '${bill.dueAt.day.toString().padLeft(2, '0')}/${bill.dueAt.month.toString().padLeft(2, '0')}';
    final amountColor = isPaid ? AppTheme.success : AppTheme.error;
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: AppTheme.shadowColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: isPaid,
                onChanged: (_) => onTogglePaid(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text('Vence em $due', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Text(
                'R\$ ${bill.amount.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w800, color: amountColor, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
