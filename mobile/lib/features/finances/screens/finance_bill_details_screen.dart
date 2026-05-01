import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../models/finance_bill_model.dart';
import '../providers/finances_provider.dart';
import 'finance_bill_form_screen.dart';

class FinanceBillDetailsScreen extends ConsumerWidget {
  final String billId;
  const FinanceBillDetailsScreen({super.key, required this.billId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billsProvider).maybeWhen(data: (v) => v, orElse: () => const <FinanceBillModel>[]);
    final bill = bills.where((b) => b.id == billId).cast<FinanceBillModel?>().firstWhere((b) => true, orElse: () => null);

    if (bill == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes'),
        ),
        body: const Center(child: Text('Conta não encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da conta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => FinanceBillFormScreen(initial: bill)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await ref.read(billsProvider.notifier).delete(bill);
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      bill.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text('R\$ ${bill.amount.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  children: [
                    _InfoRow(label: 'Categoria', value: bill.category),
                    _InfoRow(label: 'Vencimento', value: _fmtDate(bill.dueAt)),
                    _InfoRow(label: 'Status', value: bill.status == 'paid' ? 'Pago' : 'Pendente'),
                    const _InfoRow(label: 'Quem pagou', value: 'Você'),
                    const _InfoRow(label: 'Divisão', value: '50/50'),
                    if (bill.notes.isNotEmpty) _InfoRow(label: 'Observações', value: bill.notes),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => ref.read(billsProvider.notifier).togglePaid(bill),
                child: Text(bill.status == 'paid' ? 'Marcar como pendente' : 'Marcar como paga'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: AppTheme.textSecondary))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

