import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_success_screen.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
      ),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Plano atual: Free', style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 10),
              AppCard(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DuoDay Premium', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('R\$ 19,90/mês'),
                    SizedBox(height: 8),
                    Text('Desbloqueie recursos avançados para organizar a vida a dois.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const _Feature(text: 'Backup e sincronização avançada'),
              const _Feature(text: 'Temas e personalização do duo'),
              const _Feature(text: 'Relatórios completos (semana/mês)'),
              const _Feature(text: 'Notificações inteligentes'),
              const _Feature(text: 'Check-ins ilimitados'),
              const _Feature(text: 'Exportar dados'),
              const _Feature(text: 'Suporte prioritário'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppSuccessScreen(
                        message: 'Assinatura ativada com sucesso.',
                        continueRoute: '/premium',
                      ),
                    ),
                  );
                },
                child: const Text('Assinar Premium'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compra restaurada')),
                  );
                },
                child: const Text('Restaurar compra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final String text;
  const _Feature({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppTheme.success),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: AppTheme.textPrimary))),
        ],
      ),
    );
  }
}

