import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../agenda/providers/agenda_provider.dart';
import '../../finances/providers/finances_provider.dart';
import '../../tasks/providers/tasks_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authServiceProvider).currentUser;
    final partnerName = (user?.partnerName?.trim().isNotEmpty ?? false) ? user!.partnerName!.trim() : 'Seu parceiro';
    final userName = (user?.name.trim().isNotEmpty ?? false) ? user!.name.trim() : 'Você';
    final tasksAsync = ref.watch(tasksListProvider);
    final agendaAsync = ref.watch(agendaEventsProvider);
    final billsAsync = ref.watch(billsProvider);

    final pendingTasks = tasksAsync.asData?.value.where((t) => t.status != 'completed').length;
    final todayEvents = agendaAsync.asData?.value.length;
    final pendingBills = billsAsync.asData?.value.where((b) => b.status == 'pending').length;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const maxContentWidth = 600.0;
            final horizontalPadding = constraints.maxWidth > maxContentWidth
                ? ((constraints.maxWidth - maxContentWidth) / 2) + 20
                : 20.0;

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bom dia!',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            '$userName & $partnerName',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () => context.push('/notifications'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Card do Duo/parceiro
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Duo conectado',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    Text(
                      partnerName,
                        style: TextStyle(
                          color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      child: Text(
                        user?.createdAt != null
                            ? 'Conta criada em ${MaterialLocalizations.of(context).formatShortDate(user!.createdAt)}'
                            : 'Conta criada recentemente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                const AppSectionTitle(
                  title: 'Hoje',
                  subtitle: 'Visão rápida das prioridades do dia.',
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.task_outlined,
                        title: 'Tarefas de hoje',
                        subtitle: pendingTasks != null ? '$pendingTasks pendentes' : 'Carregando...',
                        color: AppTheme.info,
                        onTap: () => context.push('/tasks'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.calendar_today_outlined,
                        title: 'Eventos de hoje',
                        subtitle: todayEvents != null ? '$todayEvents hoje' : 'Carregando...',
                        color: AppTheme.warning,
                        onTap: () => context.push('/agenda'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Contas próximas',
                        subtitle: pendingBills != null ? '$pendingBills pendentes' : 'Carregando...',
                        color: AppTheme.success,
                        onTap: () => context.push('/finances'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.favorite_border,
                        title: 'Check-in pendente',
                        subtitle: 'Faça agora',
                        color: AppTheme.heart,
                        onTap: () => context.push('/checkin'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                const AppSectionTitle(title: 'Ações rápidas'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        onTap: () => context.push('/tasks/new'),
                        child: const Center(child: Text('Nova tarefa')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppCard(
                        onTap: () => context.push('/agenda/new'),
                        child: const Center(child: Text('Novo evento')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppCard(
                        onTap: () => context.push('/finances/new'),
                        child: const Center(child: Text('Nova conta')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppCard(
                        onTap: () => context.push('/checkin'),
                        child: const Center(child: Text('Fazer check-in')),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                const AppSectionTitle(title: 'Atividade recente'),
                const SizedBox(height: 16),
                _ActivityItem(
                  icon: Icons.task_alt,
                  title: 'Tarefa concluída',
                  subtitle: '$partnerName completou uma tarefa',
                  time: 'há 2 horas',
                  color: AppTheme.success,
                ),
                _ActivityItem(
                  icon: Icons.attach_money,
                  title: 'Despesa adicionada',
                  subtitle: '$userName adicionou uma despesa',
                  time: 'há 5 horas',
                  color: AppTheme.warning,
                ),
                _ActivityItem(
                  icon: Icons.favorite,
                  title: 'Check-in diário',
                  subtitle: 'Ambos fizeram check-in hoje',
                  time: 'ontem',
                  color: AppTheme.heart,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
