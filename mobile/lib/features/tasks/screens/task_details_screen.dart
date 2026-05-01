import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/tasks_provider.dart';
import '../models/task_model.dart';
import 'task_form_screen.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksListProvider).maybeWhen(
          data: (v) => v,
          orElse: () => const <TaskModel>[],
        );
    final task = tasks.where((t) => t.id == taskId).cast<TaskModel?>().firstWhere((t) => true, orElse: () => null);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes'),
        ),
        body: const Center(child: Text('Tarefa não encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TaskFormScreen(initial: task)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await ref.read(tasksListProvider.notifier).delete(task);
              if (context.mounted) context.pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description.isEmpty ? 'Sem descrição' : task.description,
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  children: [
                    _InfoRow(label: 'Responsável', value: _assigneeLabel(task.assignee)),
                    _InfoRow(label: 'Prioridade', value: _priorityLabel(task.priority)),
                    _InfoRow(label: 'Categoria', value: _categoryLabel(task.category)),
                    _InfoRow(label: 'Status', value: task.status == 'completed' ? 'Concluída' : 'Pendente'),
                    if (task.dueAt != null) _InfoRow(label: 'Data/Hora', value: _fmtDate(task.dueAt!)),
                    const _InfoRow(label: 'Criado por', value: 'Você'),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => ref.read(tasksListProvider.notifier).toggleComplete(task),
                child: Text(task.status == 'completed' ? 'Marcar como pendente' : 'Marcar como concluída'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _assigneeLabel(String v) => switch (v) {
        'me' => 'Eu',
        'partner' => 'Parceiro',
        _ => 'Ambos',
      };
  String _priorityLabel(String v) => switch (v) {
        'low' => 'Baixa',
        'high' => 'Alta',
        _ => 'Média',
      };
  String _categoryLabel(String v) => switch (v) {
        'market' => 'Mercado',
        'work' => 'Trabalho',
        'personal' => 'Pessoal',
        'other' => 'Outro',
        _ => 'Casa',
      };
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

