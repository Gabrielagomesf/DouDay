import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_generic_screen.dart';
import '../../../core/widgets/empty_state.dart';
import '../models/agenda_event_model.dart';
import '../providers/agenda_provider.dart';

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final eventsAsync = ref.watch(agendaEventsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/agenda/new'),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2035, 12, 31),
              selectedDayPredicate: (d) => isSameDay(d, selectedDay),
              onDaySelected: (sel, _) {
                ref.read(selectedDayProvider.notifier).set(sel);
                ref.read(agendaEventsProvider.notifier).refresh();
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppTheme.primarySecondary.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 1.5),
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: AppTheme.textSecondary),
              ),
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            ),
            const Divider(height: 1),
            Expanded(
              child: eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const EmptyState(
                      title: 'Nenhum compromisso hoje',
                      body: 'Adicione um evento na agenda do casal.',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.read(agendaEventsProvider.notifier).refresh(),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const maxContentWidth = 600.0;
                        final horizontalInset = constraints.maxWidth > maxContentWidth
                            ? (constraints.maxWidth - maxContentWidth) / 2
                            : 0.0;

                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 16),
                          itemCount: events.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) => _EventTile(
                            event: events[i],
                            onTap: () => context.push('/agenda/${events[i].id}'),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (e, _) => AppErrorGenericScreen(
                  title: 'Ops! Não conseguimos carregar sua agenda',
                  message: 'Tente novamente. Se persistir, verifique sua conexão.',
                  onRetry: () => ref.read(agendaEventsProvider.notifier).refresh(),
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

class _EventTile extends StatelessWidget {
  final AgendaEventModel event;
  final VoidCallback onTap;
  const _EventTile({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final time =
        '${event.startAt.hour.toString().padLeft(2, '0')}:${event.startAt.minute.toString().padLeft(2, '0')}'
        ' - ${event.endAt.hour.toString().padLeft(2, '0')}:${event.endAt.minute.toString().padLeft(2, '0')}';
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.event, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: AppTheme.textSecondary)),
                if (event.location.isNotEmpty)
                  Text(event.location, style: const TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
