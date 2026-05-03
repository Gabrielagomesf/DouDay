import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/finance_bill_model.dart';
import '../providers/finances_provider.dart';

class FinanceBillFormScreen extends ConsumerStatefulWidget {
  final FinanceBillModel? initial;
  const FinanceBillFormScreen({super.key, this.initial});

  @override
  ConsumerState<FinanceBillFormScreen> createState() => _FinanceBillFormScreenState();
}

class _FinanceBillFormScreenState extends ConsumerState<FinanceBillFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _amount;
  late final TextEditingController _notes;

  String _category = 'other';
  DateTime _dueAt = DateTime.now();
  String _responsible = 'both';
  String _splitType = 'half';
  String _status = 'pending';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial?.name ?? '');
    _amount = TextEditingController(text: widget.initial?.amount.toString() ?? '');
    _notes = TextEditingController(text: widget.initial?.notes ?? '');
    _category = widget.initial?.category ?? 'other';
    _dueAt = widget.initial?.dueAt ?? DateTime.now();
    _responsible = widget.initial?.responsible ?? 'both';
    _splitType = widget.initial?.splitType ?? 'half';
    _status = widget.initial?.status ?? 'pending';
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDue() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      initialDate: _dueAt,
    );
    if (picked != null) setState(() => _dueAt = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{
        'name': _name.text.trim(),
        'amount': double.parse(_amount.text.replaceAll(',', '.')),
        'category': _category,
        'dueAt': DateTime(_dueAt.year, _dueAt.month, _dueAt.day, 9).toIso8601String(),
        'responsible': _responsible,
        'splitType': _splitType,
        'status': _status,
        'notes': _notes.text.trim(),
      };
      final service = ref.read(financesServiceProvider);
      if (widget.initial == null) {
        await service.create(payload);
      } else {
        await service.update(widget.initial!.id, payload);
      }
      await ref.read(billsProvider.notifier).refresh();
      await ref.read(financesSummaryProvider.notifier).refresh();
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
        title: Text(widget.initial == null ? 'Nova conta' : 'Editar conta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nome da conta'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Valor total'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o valor';
                    final parsed = double.tryParse(v.replaceAll(',', '.'));
                    if (parsed == null) return 'Valor inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: const [
                    DropdownMenuItem(value: 'rent', child: Text('Aluguel')),
                    DropdownMenuItem(value: 'internet', child: Text('Internet')),
                    DropdownMenuItem(value: 'market', child: Text('Mercado')),
                    DropdownMenuItem(value: 'leisure', child: Text('Lazer')),
                    DropdownMenuItem(value: 'transport', child: Text('Transporte')),
                    DropdownMenuItem(value: 'subscriptions', child: Text('Assinaturas')),
                    DropdownMenuItem(value: 'other', child: Text('Outros')),
                  ],
                  onChanged: (v) => setState(() => _category = v ?? 'other'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickDue,
                  icon: const Icon(Icons.event),
                  label: Text(
                    'Vencimento: ${_dueAt.day.toString().padLeft(2, '0')}/${_dueAt.month.toString().padLeft(2, '0')}/${_dueAt.year}',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _responsible,
                  decoration: const InputDecoration(labelText: 'Responsável pelo pagamento'),
                  items: const [
                    DropdownMenuItem(value: 'me', child: Text('Eu')),
                    DropdownMenuItem(value: 'partner', child: Text('Parceiro')),
                    DropdownMenuItem(value: 'both', child: Text('Ambos')),
                  ],
                  onChanged: (v) => setState(() => _responsible = v ?? 'both'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _splitType,
                  decoration: const InputDecoration(labelText: 'Divisão'),
                  items: const [
                    DropdownMenuItem(value: 'half', child: Text('50/50')),
                    DropdownMenuItem(value: 'fixed', child: Text('Valor fixo')),
                    DropdownMenuItem(value: 'percent', child: Text('Por porcentagem')),
                  ],
                  onChanged: (v) => setState(() => _splitType = v ?? 'half'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'pending', child: Text('Pendente')),
                    DropdownMenuItem(value: 'paid', child: Text('Pago')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'pending'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notes,
                  decoration: const InputDecoration(labelText: 'Observações'),
                  minLines: 2,
                  maxLines: 5,
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

