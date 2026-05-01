import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/tasks_provider.dart';
import '../models/task_model.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/new'),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _FiltersRow(
                onChange: () => ref.read(tasksListProvider.notifier).refresh(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const EmptyState(
                      title: 'Nenhuma tarefa ainda',
                      body: 'Crie sua primeira tarefa e compartilhe a rotina.',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.read(tasksListProvider.notifier).refresh(),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const maxContentWidth = 600.0;
                        final horizontalInset = constraints.maxWidth > maxContentWidth
                            ? (constraints.maxWidth - maxContentWidth) / 2
                            : 0.0;

                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 16),
                          itemCount: tasks.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, i) => _TaskTile(
                            task: tasks[i],
                            onToggle: () => ref.read(tasksListProvider.notifier).toggleComplete(tasks[i]),
                            onOpen: () => context.push('/tasks/${tasks[i].id}'),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Erro ao carregar tarefas',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => ref.read(tasksListProvider.notifier).refresh(),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersRow extends ConsumerWidget {
  final VoidCallback onChange;
  const _FiltersRow({required this.onChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(tasksQueryProvider);
    final filter = query.filter;
    final assignee = query.assignee;

    Widget chip({
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(
            label: 'Todas',
            selected: filter == null,
            onTap: () {
              ref.read(tasksQueryProvider.notifier).setFilter(null);
              onChange();
            },
          ),
          const SizedBox(width: 8),
          chip(
            label: 'Hoje',
            selected: filter == 'today',
            onTap: () {
              ref.read(tasksQueryProvider.notifier).setFilter('today');
              onChange();
            },
          ),
          const SizedBox(width: 8),
          chip(
            label: 'Atrasadas',
            selected: filter == 'overdue',
            onTap: () {
              ref.read(tasksQueryProvider.notifier).setFilter('overdue');
              onChange();
            },
          ),
          const SizedBox(width: 8),
          chip(
            label: 'Concluídas',
            selected: filter == 'completed',
            onTap: () {
              ref.read(tasksQueryProvider.notifier).setFilter('completed');
              onChange();
            },
          ),
          const SizedBox(width: 16),
          chip(
            label: 'Minhas',
            selected: assignee == 'me',
            onTap: () {
              ref.read(tasksQueryProvider.notifier).setAssignee('me');
              onChange();
            },
          ),
          const SizedBox(width: 8),
          chip(
            label: 'Parceiro',
            selected: assignee == 'partner',
            onTap: () {
              ref.read(tasksQueryProvider.notifier).setAssignee('partner');
              onChange();
            },
          ),
          const SizedBox(width: 8),
          chip(
            label: 'Ambos',
            selected: assignee == 'both' || assignee == null,
            onTap: () {
              ref.read(tasksQueryProvider.notifier).setAssignee('both');
              onChange();
            },
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onOpen;

  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == 'completed';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: isDone,
                onChanged: (_) => onToggle(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_assigneeLabel(task.assignee)} • ${_priorityLabel(task.priority)} • ${_categoryLabel(task.category)}',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

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
