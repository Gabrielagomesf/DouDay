import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/notifications_provider.dart';
import '../models/app_notification_model.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationsProvider.notifier).clear(),
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: SafeArea(
        child: async.when(
          data: (items) {
            if (items.isEmpty) {
              return const EmptyState(
                title: 'Nenhuma notificação',
                body: 'Quando algo acontecer, você verá por aqui.',
              );
            }
            return RefreshIndicator(
              onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const maxContentWidth = 600.0;
                  final horizontalInset =
                      constraints.maxWidth > maxContentWidth ? (constraints.maxWidth - maxContentWidth) / 2 : 0.0;

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _Tile(item: items[i]),
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

class _Tile extends ConsumerWidget {
  final AppNotificationModel item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      onTap: () => ref.read(notificationsProvider.notifier).toggleRead(item),
      child: Row(
        children: [
          Icon(
            item.isRead ? Icons.notifications_none : Icons.notifications,
            color: item.isRead ? AppTheme.textTertiary : AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(item.body, style: const TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Text(item.isRead ? 'Lida' : 'Nova', style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

