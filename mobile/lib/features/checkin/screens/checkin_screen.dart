import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/checkin_provider.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  String _mood = 'neutral';
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayAsync = ref.watch(todayCheckinProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Diário'),
        actions: [
          TextButton(
            onPressed: () => context.push('/checkin/history'),
            child: const Text('Histórico'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: todayAsync.when(
            data: (existing) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Como você está se sentindo hoje?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _moodChip('very_good', 'Muito bem'),
                      _moodChip('good', 'Bem'),
                      _moodChip('neutral', 'Neutro'),
                      _moodChip('tired', 'Cansado'),
                      _moodChip('stressed', 'Estressado'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _comment,
                    decoration: const InputDecoration(labelText: 'Quer comentar algo? (opcional)'),
                    minLines: 2,
                    maxLines: 5,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(todayCheckinProvider.notifier).submit(mood: _mood, comment: _comment.text.trim());
                      await ref.read(checkinHistoryProvider.notifier).refresh();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Check-in enviado')),
                      );
                    },
                    child: Text(existing == null ? 'Enviar' : 'Atualizar'),
                  ),
                ],
              );
            },
            error: (e, _) => Center(
              child: ElevatedButton(
                onPressed: () => ref.invalidate(todayCheckinProvider),
                child: const Text('Tentar novamente'),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _moodChip(String value, String label) {
    final selected = _mood == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _mood = value),
    );
  }
}
