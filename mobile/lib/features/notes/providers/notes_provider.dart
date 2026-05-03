import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note_model.dart';
import '../services/notes_service.dart';

final notesServiceProvider = Provider<NotesService>((ref) => NotesService());

final notesQueryProvider = NotifierProvider<NotesQueryNotifier, String>(NotesQueryNotifier.new);

class NotesQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String v) => state = v;
}

final notesListProvider = AsyncNotifierProvider<NotesListNotifier, List<NoteModel>>(NotesListNotifier.new);

class NotesListNotifier extends AsyncNotifier<List<NoteModel>> {
  @override
  Future<List<NoteModel>> build() async {
    final q = ref.watch(notesQueryProvider);
    final raw = await ref.read(notesServiceProvider).list(q: q);
    final list = [...raw]..sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        final da = a.updatedAt ?? a.createdAt;
        final db = b.updatedAt ?? b.createdAt;
        if (da != null && db != null) return db.compareTo(da);
        return 0;
      });
    return list;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

