import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/task_model.dart';
import '../providers/tasks_provider.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final TaskModel? initial;
  const TaskFormScreen({super.key, this.initial});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;

  String _assignee = 'both';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String _priority = 'medium';
  String _category = 'home';
  String _repeat = 'none';
  String _reminder = 'none';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initial?.title ?? '');
    _description = TextEditingController(text: widget.initial?.description ?? '');
    _assignee = widget.initial?.assignee ?? 'both';
    _priority = widget.initial?.priority ?? 'medium';
    _category = widget.initial?.category ?? 'home';
    _repeat = widget.initial?.repeat ?? 'none';
    _reminder = widget.initial?.reminder ?? 'none';
    if (widget.initial?.dueAt != null) {
      final d = widget.initial!.dueAt!;
      _dueDate = DateTime(d.year, d.month, d.day);
      _dueTime = TimeOfDay(hour: d.hour, minute: d.minute);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  DateTime? _composeDueAt() {
    if (_dueDate == null) return null;
    final time = _dueTime ?? const TimeOfDay(hour: 9, minute: 0);
    return DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day, time.hour, time.minute);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      initialDate: _dueDate ?? now,
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _dueTime = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'assignee': _assignee,
        'dueAt': _composeDueAt()?.toIso8601String(),
        'priority': _priority,
        'category': _category,
        'repeat': _repeat,
        'reminder': _reminder,
      };

      final service = ref.read(tasksServiceProvider);
      if (widget.initial == null) {
        await service.create(payload);
      } else {
        await service.update(widget.initial!.id, payload);
      }

      await ref.read(tasksListProvider.notifier).refresh();
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
    final editing = widget.initial != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Editar tarefa' : 'Criar tarefa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Título da tarefa'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe um título' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  minLines: 2,
                  maxLines: 6,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _assignee,
                  decoration: const InputDecoration(labelText: 'Responsável'),
                  items: const [
                    DropdownMenuItem(value: 'me', child: Text('Eu')),
                    DropdownMenuItem(value: 'partner', child: Text('Parceiro')),
                    DropdownMenuItem(value: 'both', child: Text('Ambos')),
                  ],
                  onChanged: (v) => setState(() => _assignee = v ?? 'both'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(_dueDate == null
                            ? 'Data'
                            : '${_dueDate!.day.toString().padLeft(2, '0')}/${_dueDate!.month.toString().padLeft(2, '0')}/${_dueDate!.year}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(_dueTime == null ? 'Hora' : _dueTime!.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _priority,
                  decoration: const InputDecoration(labelText: 'Prioridade'),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Baixa')),
                    DropdownMenuItem(value: 'medium', child: Text('Média')),
                    DropdownMenuItem(value: 'high', child: Text('Alta')),
                  ],
                  onChanged: (v) => setState(() => _priority = v ?? 'medium'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: const [
                    DropdownMenuItem(value: 'home', child: Text('Casa')),
                    DropdownMenuItem(value: 'market', child: Text('Mercado')),
                    DropdownMenuItem(value: 'work', child: Text('Trabalho')),
                    DropdownMenuItem(value: 'personal', child: Text('Pessoal')),
                    DropdownMenuItem(value: 'other', child: Text('Outro')),
                  ],
                  onChanged: (v) => setState(() => _category = v ?? 'home'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _repeat,
                  decoration: const InputDecoration(labelText: 'Repetição'),
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('Não repetir')),
                    DropdownMenuItem(value: 'daily', child: Text('Diariamente')),
                    DropdownMenuItem(value: 'weekly', child: Text('Semanalmente')),
                    DropdownMenuItem(value: 'monthly', child: Text('Mensalmente')),
                  ],
                  onChanged: (v) => setState(() => _repeat = v ?? 'none'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _reminder,
                  decoration: const InputDecoration(labelText: 'Lembrete'),
                  items: const [
                    DropdownMenuItem(value: '10m', child: Text('10 min antes')),
                    DropdownMenuItem(value: '1h', child: Text('1h antes')),
                    DropdownMenuItem(value: '1d', child: Text('1 dia antes')),
                    DropdownMenuItem(value: 'none', child: Text('Sem lembrete')),
                  ],
                  onChanged: (v) => setState(() => _reminder = v ?? 'none'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Salvando...' : 'Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

