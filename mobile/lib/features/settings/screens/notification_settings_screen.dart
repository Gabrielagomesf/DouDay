import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widgets/app_page.dart';

/// Preferências locais até existir API dedicada.
class NotificationPrefs {
  static const _prefix = 'notif_pref_';

  static Future<bool> pushMaster() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('${_prefix}push_master') ?? true;
  }

  static Future<void> setPushMaster(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('${_prefix}push_master', v);
  }

  static Future<bool> getBool(String key, bool def) async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('$_prefix$key') ?? def;
  }

  static Future<void> setBool(String key, bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('$_prefix$key', v);
  }

  static Future<int> minuteOfDay() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt('${_prefix}minute_day') ?? (20 * 60);
  }

  static Future<void> setMinuteOfDay(int m) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('${_prefix}minute_day', m);
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _loading = true;
  bool pushMaster = true;
  bool tasks = true;
  bool bills = true;
  bool agenda = true;
  bool checkin = true;
  bool missions = true;
  bool dailyReminder = true;
  TimeOfDay preferred = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    pushMaster = await NotificationPrefs.pushMaster();
    tasks = await NotificationPrefs.getBool('tasks', true);
    bills = await NotificationPrefs.getBool('bills', true);
    agenda = await NotificationPrefs.getBool('agenda', true);
    checkin = await NotificationPrefs.getBool('checkin', true);
    missions = await NotificationPrefs.getBool('missions', true);
    dailyReminder = await NotificationPrefs.getBool('daily', true);
    final m = await NotificationPrefs.minuteOfDay();
    preferred = TimeOfDay(hour: m ~/ 60, minute: m % 60);
    setState(() => _loading = false);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: preferred);
    if (t != null) {
      setState(() => preferred = t);
      await NotificationPrefs.setMinuteOfDay(t.hour * 60 + t.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações de notificações')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SwitchListTile(
                value: pushMaster,
                onChanged: (v) async {
                  setState(() => pushMaster = v);
                  await NotificationPrefs.setPushMaster(v);
                },
                title: const Text('Notificações push'),
                subtitle: const Text('Ativar ou desativar todos os alertas no dispositivo'),
              ),
              const Divider(height: 24),
              SwitchListTile(
                value: tasks,
                onChanged: pushMaster
                    ? (v) async {
                        setState(() => tasks = v);
                        await NotificationPrefs.setBool('tasks', v);
                      }
                    : null,
                title: const Text('Tarefas'),
              ),
              SwitchListTile(
                value: bills,
                onChanged: pushMaster
                    ? (v) async {
                        setState(() => bills = v);
                        await NotificationPrefs.setBool('bills', v);
                      }
                    : null,
                title: const Text('Contas'),
              ),
              SwitchListTile(
                value: agenda,
                onChanged: pushMaster
                    ? (v) async {
                        setState(() => agenda = v);
                        await NotificationPrefs.setBool('agenda', v);
                      }
                    : null,
                title: const Text('Agenda'),
              ),
              SwitchListTile(
                value: checkin,
                onChanged: pushMaster
                    ? (v) async {
                        setState(() => checkin = v);
                        await NotificationPrefs.setBool('checkin', v);
                      }
                    : null,
                title: const Text('Check-in'),
              ),
              SwitchListTile(
                value: missions,
                onChanged: pushMaster
                    ? (v) async {
                        setState(() => missions = v);
                        await NotificationPrefs.setBool('missions', v);
                      }
                    : null,
                title: const Text('Missões'),
              ),
              SwitchListTile(
                value: dailyReminder,
                onChanged: pushMaster
                    ? (v) async {
                        setState(() => dailyReminder = v);
                        await NotificationPrefs.setBool('daily', v);
                      }
                    : null,
                title: const Text('Lembrete diário'),
              ),
              const SizedBox(height: 8),
              ListTile(
                enabled: pushMaster,
                title: const Text('Horário preferido dos lembretes'),
                subtitle: Text(preferred.format(context)),
                trailing: const Icon(Icons.schedule_outlined),
                onTap: pushMaster ? _pickTime : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
