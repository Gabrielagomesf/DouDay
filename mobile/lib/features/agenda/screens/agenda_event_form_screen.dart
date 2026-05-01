import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/agenda_provider.dart';
import '../models/agenda_event_model.dart';

class AgendaEventFormScreen extends ConsumerStatefulWidget {
  final AgendaEventModel? initial;
  const AgendaEventFormScreen({super.key, this.initial});

  @override
  ConsumerState<AgendaEventFormScreen> createState() => _AgendaEventFormScreenState();
}

class _AgendaEventFormScreenState extends ConsumerState<AgendaEventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _location;

  String _participants = 'both';
  late DateTime _date;
  TimeOfDay? _start;
  TimeOfDay? _end;
  String _repeat = 'none';
  String _reminder = 'none';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initial?.title ?? '');
    _description = TextEditingController(text: widget.initial?.description ?? '');
    _location = TextEditingController(text: widget.initial?.location ?? '');
    _participants = widget.initial?.participants ?? 'both';
    _repeat = widget.initial?.repeat ?? 'none';
    _reminder = widget.initial?.reminder ?? 'none';

    final DateTime base = widget.initial?.startAt ?? ref.read(selectedDayProvider);
    _date = DateTime(base.year, base.month, base.day);
    _start = TimeOfDay(hour: (widget.initial?.startAt.hour ?? 9), minute: (widget.initial?.startAt.minute ?? 0));
    _end = TimeOfDay(hour: (widget.initial?.endAt.hour ?? 10), minute: (widget.initial?.endAt.minute ?? 0));
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _location.dispose();
    super.dispose();
  }

  DateTime _compose(DateTime day, TimeOfDay t) => DateTime(day.year, day.month, day.day, t.hour, t.minute);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      initialDate: _date,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? (_start ?? const TimeOfDay(hour: 9, minute: 0)) : (_end ?? const TimeOfDay(hour: 10, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _start = picked;
        } else {
          _end = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final day = _date;
    final start = _start;
    final end = _end;
    if (start == null || end == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe data e horário')));
      return;
    }

    final startAt = _compose(day, start);
    final endAt = _compose(day, end);
    if (!endAt.isAfter(startAt)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hora final deve ser maior que inicial')));
      return;
    }

    setState(() => _saving = true);
    try {
      final service = ref.read(agendaServiceProvider);
      final payload = <String, dynamic>{
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'location': _location.text.trim(),
        'participants': _participants,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'repeat': _repeat,
        'reminder': _reminder,
      };

      if (widget.initial == null) {
        await service.create(payload);
      } else {
        await service.update(widget.initial!.id, payload);
      }

      await ref.read(agendaEventsProvider.notifier).refresh();
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
        title: Text(widget.initial == null ? 'Novo evento' : 'Editar evento'),
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
                TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(labelText: 'Local'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _participants,
                  decoration: const InputDecoration(labelText: 'Participantes'),
                  items: const [
                    DropdownMenuItem(value: 'me', child: Text('Eu')),
                    DropdownMenuItem(value: 'partner', child: Text('Parceiro')),
                    DropdownMenuItem(value: 'both', child: Text('Ambos')),
                  ],
                  onChanged: (v) => setState(() => _participants = v ?? 'both'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(
                          '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickTime(isStart: true),
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(_start == null ? 'Início' : _start!.format(context)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickTime(isStart: false),
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(_end == null ? 'Fim' : _end!.format(context)),
                      ),
                    ),
                  ],
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

