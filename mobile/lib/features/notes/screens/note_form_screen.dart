import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';

class NoteFormScreen extends ConsumerStatefulWidget {
  final NoteModel? initial;
  const NoteFormScreen({super.key, this.initial});

  @override
  ConsumerState<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends ConsumerState<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _content;
  String _category = 'general';
  bool _pinned = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initial?.title ?? '');
    _content = TextEditingController(text: widget.initial?.content ?? '');
    _category = widget.initial?.category ?? 'general';
    _pinned = widget.initial?.isPinned ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'title': _title.text.trim(),
        'content': _content.text,
        'category': _category,
        'isPinned': _pinned,
      };
      final service = ref.read(notesServiceProvider);
      if (widget.initial == null) {
        await service.create(payload);
      } else {
        await service.update(widget.initial!.id, payload);
      }
      await ref.read(notesListProvider.notifier).refresh();
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'Nova nota' : 'Editar nota'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: const [
                    DropdownMenuItem(value: 'general', child: Text('Geral')),
                    DropdownMenuItem(value: 'home', child: Text('Casa')),
                    DropdownMenuItem(value: 'work', child: Text('Trabalho')),
                    DropdownMenuItem(value: 'personal', child: Text('Pessoal')),
                    DropdownMenuItem(value: 'other', child: Text('Outro')),
                  ],
                  onChanged: (v) => setState(() => _category = v ?? 'general'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _pinned,
                  onChanged: (v) => setState(() => _pinned = v),
                  title: const Text('Fixar nota'),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _content,
                  minLines: 6,
                  maxLines: 16,
                  decoration: const InputDecoration(labelText: 'Conteúdo'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'Salvando...' : 'Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

