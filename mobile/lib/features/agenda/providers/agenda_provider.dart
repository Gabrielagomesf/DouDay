import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/agenda_event_model.dart';
import '../services/agenda_service.dart';

final agendaServiceProvider = Provider<AgendaService>((ref) => AgendaService());

final selectedDayProvider = NotifierProvider<SelectedDayNotifier, DateTime>(SelectedDayNotifier.new);

class SelectedDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void set(DateTime day) => state = DateTime(day.year, day.month, day.day);
}

/// Eventos de hoje para o dashboard (não depende do dia selecionado na agenda).
final todayAgendaEventsProvider = FutureProvider<List<AgendaEventModel>>((ref) async {
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, now.day);
  final to = from.add(const Duration(days: 1));
  return ref.read(agendaServiceProvider).list(from: from, to: to);
});

final agendaEventsProvider = AsyncNotifierProvider<AgendaEventsNotifier, List<AgendaEventModel>>(
  AgendaEventsNotifier.new,
);

class AgendaEventsNotifier extends AsyncNotifier<List<AgendaEventModel>> {
  @override
  Future<List<AgendaEventModel>> build() async {
    final day = ref.watch(selectedDayProvider);
    final from = DateTime(day.year, day.month, day.day);
    final to = from.add(const Duration(days: 1));
    return ref.read(agendaServiceProvider).list(from: from, to: to);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

