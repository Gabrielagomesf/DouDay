import 'package:flutter/material.dart';

import '../../../core/widgets/app_page.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool tasks = true;
  bool bills = true;
  bool agenda = true;
  bool checkin = true;
  bool missions = true;
  bool dailyReminder = true;
  TimeOfDay preferred = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: preferred);
    if (t != null) setState(() => preferred = t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações de notificações')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SwitchListTile(value: tasks, onChanged: (v) => setState(() => tasks = v), title: const Text('Tarefas')),
              SwitchListTile(value: bills, onChanged: (v) => setState(() => bills = v), title: const Text('Contas')),
              SwitchListTile(value: agenda, onChanged: (v) => setState(() => agenda = v), title: const Text('Agenda')),
              SwitchListTile(value: checkin, onChanged: (v) => setState(() => checkin = v), title: const Text('Check-in')),
              SwitchListTile(value: missions, onChanged: (v) => setState(() => missions = v), title: const Text('Missões')),
              SwitchListTile(
                value: dailyReminder,
                onChanged: (v) => setState(() => dailyReminder = v),
                title: const Text('Lembrete diário'),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Horário preferido dos lembretes'),
                subtitle: Text(preferred.format(context)),
                trailing: const Icon(Icons.schedule_outlined),
                onTap: _pickTime,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

