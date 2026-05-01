import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_card.dart';
import '../../agenda/providers/agenda_provider.dart';
import 'agenda_event_form_screen.dart';

class AgendaEventDetailsScreen extends ConsumerWidget {
  final String eventId;
  const AgendaEventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(agendaEventsProvider).maybeWhen(data: (v) => v, orElse: () => const []);
    final event = events.where((e) => e.id == eventId).cast<dynamic>().firstWhere((e) => true, orElse: () => null);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhe do evento')),
        body: const Center(child: Text('Evento não encontrado')),
      );
    }

    final time =
        '${event.startAt.hour.toString().padLeft(2, '0')}:${event.startAt.minute.toString().padLeft(2, '0')}'
        ' - ${event.endAt.hour.toString().padLeft(2, '0')}:${event.endAt.minute.toString().padLeft(2, '0')}';
    final date =
        '${event.startAt.day.toString().padLeft(2, '0')}/${event.startAt.month.toString().padLeft(2, '0')}/${event.startAt.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do evento'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AgendaEventFormScreen(initial: event)),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(agendaServiceProvider).remove(event.id);
              await ref.read(agendaEventsProvider.notifier).refresh();
              if (context.mounted) context.pop();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(event.description.isEmpty ? 'Sem descrição' : event.description),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _Row(label: 'Data', value: date),
                  _Row(label: 'Horário', value: time),
                  _Row(label: 'Local', value: event.location.isEmpty ? '-' : event.location),
                  _Row(label: 'Participantes', value: _participants(event.participants)),
                  const _Row(label: 'Criado por', value: 'Você'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _participants(String v) => switch (v) {
        'me' => 'Você',
        'partner' => 'Parceiro',
        _ => 'Ambos',
      };
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}

