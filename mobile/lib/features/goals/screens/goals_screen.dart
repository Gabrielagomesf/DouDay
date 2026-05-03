import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

/// Metas compartilhadas (UI doc): lista com barra roxa e percentagem — dados locais até API dedicada.
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  static const List<_GoalItem> _demo = [
    _GoalItem(title: 'Viagem dos sonhos', progress: 0.42),
    _GoalItem(title: 'Reserva de emergência', progress: 0.68),
    _GoalItem(title: 'Reforma da sala', progress: 0.15),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Metas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Em breve: criar nova meta')),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _demo.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Conquistem juntos — acompanhem o progresso das metas do casal.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
                ),
              );
            }
            final g = _demo[i - 1];
            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          g.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${(g.progress * 100).round()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: g.progress,
                      minHeight: 10,
                      backgroundColor: AppTheme.borderLight,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GoalItem {
  final String title;
  final double progress;
  const _GoalItem({required this.title, required this.progress});
}
