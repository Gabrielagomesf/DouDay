import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../agenda/models/agenda_event_model.dart';
import '../../agenda/providers/agenda_provider.dart';
import '../../checkin/checkin_mood_utils.dart';
import '../../checkin/providers/checkin_provider.dart';
import '../../finances/models/finance_bill_model.dart';
import '../../finances/providers/finances_provider.dart';
import '../../missions/models/mission_model.dart';
import '../../missions/providers/missions_provider.dart';
import '../../tasks/models/task_model.dart';
import '../../tasks/providers/tasks_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static String _firstName(String name) {
    final t = name.trim();
    if (t.isEmpty) return 'você';
    return t.split(RegExp(r'\s+')).first;
  }

  static String _greetingNow() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia';
    if (h < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static TaskModel? _nextTask(List<TaskModel> tasks) {
    final pending = tasks.where((t) => t.status != 'completed').toList();
    if (pending.isEmpty) return null;
    int score(TaskModel t) {
      if (t.dueAt == null) return 99999999999999;
      return t.dueAt!.millisecondsSinceEpoch;
    }

    pending.sort((a, b) => score(a).compareTo(score(b)));
    return pending.first;
  }

  static AgendaEventModel? _nextEventToday(List<AgendaEventModel> events) {
    if (events.isEmpty) return null;
    final sorted = [...events]..sort((a, b) => a.startAt.compareTo(b.startAt));
    return sorted.first;
  }

  static FinanceBillModel? _nextBill(List<FinanceBillModel> bills) {
    if (bills.isEmpty) return null;
    final sorted = [...bills]..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return sorted.first;
  }

  static MissionModel? _nextMission(List<MissionModel> daily) {
    final pending = daily.where((m) => m.status != 'completed').toList();
    if (pending.isEmpty) return null;
    return pending.first;
  }

  static String _relativeUpdated(TaskModel t) {
    final ref = t.updatedAt ?? t.completedAt ?? t.createdAt;
    if (ref == null) return '';
    final now = DateTime.now();
    final diff = now.difference(ref);
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours} h';
    if (diff.inDays == 1) return 'ontem';
    return DateFormat.MMMd('pt_BR').format(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authServiceProvider).currentUser;
    final partnerName =
        (user?.partnerName?.trim().isNotEmpty ?? false) ? user!.partnerName!.trim() : 'Seu parceiro';
    final userName = (user?.name.trim().isNotEmpty ?? false) ? user!.name.trim() : 'Você';
    final duoLabel = '$userName & $partnerName';

    final tasksDash = ref.watch(dashboardTasksProvider);
    final billsDash = ref.watch(dashboardPendingBillsProvider);
    final agendaToday = ref.watch(todayAgendaEventsProvider);
    final missionsAsync = ref.watch(missionsProvider);
    final checkinToday = ref.watch(todayCheckinProvider);

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final pendingTasksCount = tasksDash.maybeWhen(
      data: (tasks) => tasks.where((t) {
        if (t.status == 'completed') return false;
        if (t.dueAt == null) return false;
        return _sameDay(t.dueAt!, todayStart);
      }).length,
      orElse: () => null,
    );
    final eventsTodayCount = agendaToday.maybeWhen(data: (e) => e.length, orElse: () => null);
    final pendingBillsCount = billsDash.maybeWhen(data: (b) => b.length, orElse: () => null);

    final nextTask = tasksDash.maybeWhen(data: _nextTask, orElse: () => null);
    final nextEvent = agendaToday.maybeWhen(data: _nextEventToday, orElse: () => null);
    final nextBill = billsDash.maybeWhen(data: _nextBill, orElse: () => null);
    final nextMission = missionsAsync.maybeWhen(data: (m) => _nextMission(m.daily), orElse: () => null);
    final moodLine = checkinToday.maybeWhen(
      data: (c) => c == null ? 'Pendente hoje' : 'Seu humor: ${moodLabelPt(c.mood)}',
      orElse: () => 'Carregando…',
    );

    final recentDone = tasksDash.maybeWhen(
      data: (tasks) {
        final done = tasks.where((t) => t.status == 'completed').toList();
        done.sort((a, b) {
          final da = a.updatedAt ?? a.completedAt ?? DateTime(2000);
          final db = b.updatedAt ?? b.completedAt ?? DateTime(2000);
          return db.compareTo(da);
        });
        return done.take(3).toList();
      },
      orElse: () => <TaskModel>[],
    );

    final dateLine = DateFormat.yMMMMEEEEd('pt_BR').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.background,
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                      child: Text(
                        _firstName(userName).isNotEmpty
                            ? _firstName(userName)[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_greetingNow()}, ${_firstName(userName)} 👋',
                            style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                          ),
                          Text(
                            dateLine,
                            style: const TextStyle(fontSize: 13, color: AppTheme.textTertiary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            duoLabel,
                            style: const TextStyle(
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

                const SizedBox(height: 16),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/dashboard_couple.png',
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

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
                          const Icon(Icons.favorite, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            'Nome do Duo',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        duoLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

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
                        subtitle: pendingTasksCount != null ? '$pendingTasksCount pendentes' : 'Carregando...',
                        color: AppTheme.info,
                        onTap: () => context.push('/tasks'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.calendar_today_outlined,
                        title: 'Eventos de hoje',
                        subtitle: eventsTodayCount != null ? '$eventsTodayCount no dia' : 'Carregando...',
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
                        subtitle: pendingBillsCount != null ? '$pendingBillsCount pendentes' : 'Carregando...',
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

                const SizedBox(height: 28),

                const AppSectionTitle(
                  title: 'Destaques',
                  subtitle: 'Próxima tarefa, agenda, conta, missão e humor.',
                ),
                const SizedBox(height: 12),

                _HighlightTile(
                  icon: Icons.task_alt,
                  title: 'Próxima tarefa',
                  subtitle: nextTask == null ? 'Nenhuma pendente' : nextTask.title,
                  onTap: nextTask != null ? () => context.push('/tasks/${nextTask.id}') : () => context.push('/tasks/new'),
                ),
                _HighlightTile(
                  icon: Icons.event,
                  title: 'Próximo compromisso',
                  subtitle: nextEvent == null
                      ? 'Nada agendado hoje'
                      : '${DateFormat.Hm('pt_BR').format(nextEvent.startAt)} · ${nextEvent.title}',
                  onTap: () => context.push('/agenda'),
                ),
                _HighlightTile(
                  icon: Icons.payments_outlined,
                  title: 'Conta vencendo',
                  subtitle: nextBill == null
                      ? 'Sem contas pendentes'
                      : '${nextBill.name} · ${DateFormat.MMMd('pt_BR').format(nextBill.dueAt)}',
                  onTap: nextBill != null ? () => context.push('/finances/${nextBill.id}') : () => context.push('/finances'),
                ),
                _HighlightTile(
                  icon: Icons.flag_outlined,
                  title: 'Missão do dia',
                  subtitle: nextMission == null ? 'Tudo feito ou sem missões' : nextMission.title,
                  onTap: () => context.push('/missions'),
                ),
                _HighlightTile(
                  icon: Icons.sentiment_satisfied_alt,
                  title: 'Humor do casal',
                  subtitle: moodLine,
                  onTap: () => context.push('/checkin'),
                ),

                const SizedBox(height: 24),

                const AppSectionTitle(
                  title: 'Atalhos',
                  subtitle: 'Tarefas, agenda, finanças, metas e check-in.',
                ),
                const SizedBox(height: 12),
                _ShortcutGrid(
                  items: [
                    (icon: Icons.task_alt_outlined, label: 'Tarefas', onTap: () => context.push('/tasks')),
                    (icon: Icons.calendar_today_outlined, label: 'Agenda', onTap: () => context.push('/agenda')),
                    (icon: Icons.account_balance_wallet_outlined, label: 'Finanças', onTap: () => context.push('/finances')),
                    (icon: Icons.flag_outlined, label: 'Metas', onTap: () => context.push('/goals')),
                    (icon: Icons.favorite_border, label: 'Check-in', onTap: () => context.push('/checkin')),
                  ],
                ),

                const SizedBox(height: 28),
                const AppSectionTitle(title: 'Atividade recente'),
                const SizedBox(height: 12),
                if (recentDone.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Quando concluírem tarefas, aparecerão aqui.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                else
                  ...recentDone.map(
                    (t) => _ActivityItem(
                      icon: Icons.task_alt,
                      title: 'Tarefa concluída',
                      subtitle: t.title,
                      time: _relativeUpdated(t),
                      color: AppTheme.success,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HighlightTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textTertiary),
          ],
        ),
      ),
    );
  }
}

typedef _ShortcutDef = ({IconData icon, String label, VoidCallback onTap});

class _ShortcutGrid extends StatelessWidget {
  final List<_ShortcutDef> items;
  const _ShortcutGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final e = items[i];
          return SizedBox(
            width: 76,
            child: Material(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              elevation: 1,
              shadowColor: AppTheme.shadowColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: e.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(e.icon, color: AppTheme.primaryColor, size: 28),
                      const SizedBox(height: 6),
                      Text(
                        e.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
        ],
      ),
    );
  }
}
