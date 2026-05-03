import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/theme_mode_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    void pick(ThemeMode m) => ref.read(themeModeProvider.notifier).setThemeMode(m);

    return Scaffold(
      appBar: AppBar(title: const Text('Aparência')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Escolha como o DuoDay segue o tema do sistema ou força claro/escuro.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Seguir o sistema'),
                      subtitle: const Text('Adapta ao modo do celular'),
                      value: ThemeMode.system,
                      groupValue: mode,
                      onChanged: (v) => v != null ? pick(v) : null,
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Claro'),
                      value: ThemeMode.light,
                      groupValue: mode,
                      onChanged: (v) => v != null ? pick(v) : null,
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Escuro'),
                      value: ThemeMode.dark,
                      groupValue: mode,
                      onChanged: (v) => v != null ? pick(v) : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
