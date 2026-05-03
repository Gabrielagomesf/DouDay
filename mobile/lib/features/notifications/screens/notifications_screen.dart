import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_generic_screen.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/notifications_provider.dart';
import '../models/app_notification_model.dart';

/// Doc: lista + filtros Todas / Não lidas.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _filterTab = 0; // 0 todas, 1 não lidas

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(notificationsProvider);
    return Scaffold(
      backgroundColor: AppTheme.background,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Todas'),
                    selected: _filterTab == 0,
                    onSelected: (_) => setState(() => _filterTab = 0),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Não lidas'),
                    selected: _filterTab == 1,
                    onSelected: (_) => setState(() => _filterTab = 1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: async.when(
          data: (items) {
            final visible =
                _filterTab == 1 ? items.where((n) => !n.isRead).toList() : items;
            if (visible.isEmpty) {
              return EmptyState(
                title: _filterTab == 1 ? 'Nenhuma não lida' : 'Nenhuma notificação',
                body: _filterTab == 1
                    ? 'Você está em dia com as novidades.'
                    : 'Quando algo acontecer, você verá por aqui.',
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
                    itemCount: visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => _Tile(item: visible[i]),
                  );
                },
              ),
            );
          },
          error: (e, _) => AppErrorGenericScreen(
            title: 'Ops! Não conseguimos carregar suas notificações',
            message: 'Tente novamente. Se persistir, verifique sua conexão.',
            onRetry: () => ref.read(notificationsProvider.notifier).refresh(),
            backRoute: '/home',
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
            notificationIcon(item.type),
            color: item.isRead ? AppTheme.textTertiary : AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(item.body, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          if (!item.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}

IconData notificationIcon(String? type) {
  final t = (type ?? '').toLowerCase();
  if (t == 'task' || t == 'tarefa') return Icons.task_alt_outlined;
  if (t == 'agenda' || t == 'event') return Icons.calendar_today_outlined;
  if (t == 'finance' || t == 'finanças' || t == 'financas') {
    return Icons.account_balance_wallet_outlined;
  }
  if (t == 'checkin') return Icons.favorite_border;
  if (t == 'system' || t == 'sistema') return Icons.settings_outlined;
  return Icons.notifications_outlined;
}
