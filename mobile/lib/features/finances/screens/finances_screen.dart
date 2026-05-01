import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/finances_provider.dart';
import '../models/finance_bill_model.dart';

class FinancesScreen extends ConsumerWidget {
  const FinancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financesSummaryProvider);
    final billsAsync = ref.watch(billsProvider);
    final status = ref.watch(financesStatusFilterProvider);

    return Scaffold(
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
              padding: const EdgeInsets.all(16),
              child: summaryAsync.when(
                data: (s) {
                  final total = (s['total'] ?? 0).toString();
                  final pending = (s['pending'] ?? 0).toString();
                  final paid = (s['paid'] ?? 0).toString();
                  return AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Metric(label: 'Total', value: 'R\$ $total'),
                        _Metric(label: 'Pendentes', value: pending),
                        _Metric(label: 'Pagas', value: paid),
                      ],
                    ),
                  );
                },
                error: (_, __) => const SizedBox.shrink(),
                loading: () => const LinearProgressIndicator(),
              ),
            ),
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
              child: billsAsync.when(
                data: (bills) {
                  if (bills.isEmpty) {
                    return const EmptyState(
                      title: 'Nenhuma conta cadastrada',
                      body: 'Adicione uma conta para acompanhar os gastos do casal.',
                    );
                  }
                  return RefreshIndicator(
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
                          padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 16),
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
                  );
                },
                error: (e, _) => Center(
                  child: ElevatedButton(
                    onPressed: () => ref.read(billsProvider.notifier).refresh(),
                    child: const Text('Tentar novamente'),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
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
        Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ],
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(value: isPaid, onChanged: (_) => onTogglePaid()),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bill.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Text('Vence em $due', style: const TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Text('R\$ ${bill.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
