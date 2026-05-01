import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/notes_provider.dart';
import '../models/note_model.dart';
import 'note_form_screen.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoteFormScreen())),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (v) {
                  ref.read(notesQueryProvider.notifier).set(v);
                  ref.read(notesListProvider.notifier).refresh();
                },
                decoration: const InputDecoration(
                  labelText: 'Buscar nota',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: notesAsync.when(
                data: (notes) {
                  if (notes.isEmpty) {
                    return const EmptyState(
                      title: 'Nenhuma nota ainda',
                      body: 'Crie uma nota para guardar ideias e combinados.',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.read(notesListProvider.notifier).refresh(),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const maxContentWidth = 600.0;
                        final horizontalInset = constraints.maxWidth > maxContentWidth
                            ? (constraints.maxWidth - maxContentWidth) / 2
                            : 0.0;

                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 16),
                          itemCount: notes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) => _NoteTile(note: notes[i]),
                        );
                      },
                    ),
                  );
                },
                error: (e, _) => Center(child: Text('Erro: $e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteTile extends ConsumerWidget {
  final NoteModel note;
  const _NoteTile({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteFormScreen(initial: note))),
      child: Row(
        children: [
          Icon(note.isPinned ? Icons.push_pin : Icons.note_outlined, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  note.content.isEmpty ? 'Sem conteúdo' : note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(notesServiceProvider).pin(note.id, !note.isPinned);
              await ref.read(notesListProvider.notifier).refresh();
            },
            icon: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
          ),
        ],
      ),
    );
  }
}

