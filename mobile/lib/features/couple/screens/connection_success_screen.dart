import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_title.dart';

class ConnectionSuccessScreen extends StatelessWidget {
  const ConnectionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          scroll: false,
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 72,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 28),
              const AppSectionTitle(
                title: 'Duo criado com sucesso',
                subtitle: 'Agora vocês podem organizar a rotina juntos.',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Ir para o app'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

