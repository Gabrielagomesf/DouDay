import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_error_generic_screen.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/tasks_provider.dart';
import '../models/task_model.dart';

/// Doc: abas Todas / Pendentes / Concluídas + lista + FAB.
class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTab);
  }

  void _onTab() {
    if (_tabController.indexIsChanging) return;
    final idx = _tabController.index;
    final filter = switch (idx) {
      1 => 'pending',
      2 => 'completed',
      _ => null,
    };
    ref.read(tasksQueryProvider.notifier).setFilter(filter);
    ref.read(tasksQueryProvider.notifier).setAssignee(null);
    ref.read(tasksListProvider.notifier).refresh();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTab);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksListProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Tarefas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Pendentes'),
            Tab(text: 'Concluídas'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/new'),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: tasksAsync.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              final tab = _tabController.index;
              final title = switch (tab) {
                1 => 'Nenhuma tarefa pendente',
                2 => 'Nenhuma tarefa concluída',
                _ => 'Nenhuma tarefa criada ainda',
              };
              final body = switch (tab) {
                1 => 'Quando houver tarefas em aberto, aparecem aqui.',
                2 => 'Conclua tarefas para vê-las nesta aba.',
                _ => 'Crie sua primeira tarefa e compartilhe a rotina com seu parceiro.',
              };
              return EmptyState(
                title: title,
                body: body,
                actionLabel: 'Criar primeira tarefa',
                onAction: () => context.push('/tasks/new'),
              );
            }
            return RefreshIndicator(
              onRefresh: () => ref.read(tasksListProvider.notifier).refresh(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const maxContentWidth = 600.0;
                  final horizontalInset =
                      constraints.maxWidth > maxContentWidth ? (constraints.maxWidth - maxContentWidth) / 2 : 0.0;

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 24),
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
          error: (e, _) => AppErrorGenericScreen(
            title: 'Ops! Não conseguimos carregar suas tarefas',
            message: 'Tente novamente. Se persistir, verifique sua conexão.',
            onRetry: () => ref.read(tasksListProvider.notifier).refresh(),
            backRoute: '/home',
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
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
