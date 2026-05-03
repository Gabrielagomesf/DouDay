import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_title.dart';

/// Layout com 3 cards principais (design DuoDay): convite, código e dica.
class ConnectPartnerChoiceScreen extends StatelessWidget {
  const ConnectPartnerChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Conecte seu parceiro')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppSectionTitle(
                title: 'Conecte seu parceiro',
                subtitle: 'Crie um Duo ou entre usando o código enviado pela outra pessoa.',
              ),
              const SizedBox(height: 20),
              AppCard(
                onTap: () => context.go('/connect-partner/invite'),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.vpn_key_outlined, color: AppTheme.primaryColor, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Criar meu Duo',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gere um código e envie ao seu parceiro.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                onTap: () => context.go('/connect-partner/enter'),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.accentPink.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.login_rounded, color: AppTheme.accentPink, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Inserir código do parceiro',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Digite o código que você recebeu.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.schedule_rounded, color: AppTheme.warning.withValues(alpha: 0.9)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'O código de convite expira em 24 horas. Se precisar, gere um novo na hora.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary, height: 1.4),
                      ),
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
