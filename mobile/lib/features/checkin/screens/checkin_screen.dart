import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/checkin_provider.dart';

/// Check-in emocional (doc): pergunta + 5 cards grandes + comentário opcional.
class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  String _mood = 'neutral';
  final _comment = TextEditingController();
  bool _hydrated = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  static const List<_MoodDef> _moods = [
    _MoodDef('very_good', 'Feliz', '😊', AppTheme.success),
    _MoodDef('neutral', 'Neutro', '😐', AppTheme.warning),
    _MoodDef('sad', 'Triste', '😢', Color(0xFF818CF8)),
    _MoodDef('tired', 'Cansado', '😮‍💨', Color(0xFFFB923C)),
    _MoodDef('stressed', 'Estressado', '😣', AppTheme.error),
  ];

  @override
  Widget build(BuildContext context) {
    ref.listen(todayCheckinProvider, (_, next) {
      next.whenData((existing) {
        if (!_hydrated && existing != null && mounted) {
          _hydrated = true;
          setState(() {
            _mood = existing.mood;
            _comment.text = existing.comment;
          });
        }
      });
    });

    final todayAsync = ref.watch(todayCheckinProvider);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Check-in emocional'),
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
                  Text(
                    'Como você está hoje?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _moods.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _moodCard(_moods[i]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _comment,
                    decoration: const InputDecoration(
                      labelText: 'Comentário (opcional)',
                      hintText: 'Quer compartilhar algo com seu parceiro?',
                    ),
                    minLines: 2,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
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

  Widget _moodCard(_MoodDef m) {
    final selected = _mood == m.value;
    return Material(
      color: selected ? m.accent.withValues(alpha: 0.12) : AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: selected ? 2 : 0,
      shadowColor: AppTheme.shadowColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _mood = m.value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? m.accent : AppTheme.borderLight,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(m.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  m.label,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppTheme.textPrimary : AppTheme.textSecondary,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: m.accent, size: 26)
              else
                Icon(Icons.circle_outlined, color: AppTheme.borderLight, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodDef {
  final String value;
  final String label;
  final String emoji;
  final Color accent;
  const _MoodDef(this.value, this.label, this.emoji, this.accent);
}
