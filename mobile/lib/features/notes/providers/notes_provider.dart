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
    return ref.read(notesServiceProvider).list(q: q);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

