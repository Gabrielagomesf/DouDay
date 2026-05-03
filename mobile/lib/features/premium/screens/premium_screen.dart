import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_screen.dart';
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
          child: SingleChildScrollView(
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
                const Text('Benefícios', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 10),
                const _Feature(text: 'Backup e sincronização avançada'),
                const _Feature(text: 'Temas e personalização do duo'),
                const _Feature(text: 'Relatórios completos (semana/mês)'),
                const _Feature(text: 'Notificações inteligentes'),
                const _Feature(text: 'Check-ins ilimitados'),
                const _Feature(text: 'Exportar dados'),
                const _Feature(text: 'Suporte prioritário'),
                const SizedBox(height: 24),
                const Text('Histórico de pagamentos', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.receipt_long_outlined, color: AppTheme.primaryColor.withValues(alpha: 0.7)),
                      const SizedBox(height: 10),
                      const Text(
                        'Nenhuma compra registrada',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Quando você assinar pela loja (Google Play / App Store), os recibos aparecerão aqui.',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AppErrorScreen(
                          title: 'Pagamento não concluído',
                          message:
                              'Não foi possível confirmar a compra. Verifique o método de pagamento ou tente novamente.',
                          onRetry: () => Navigator.of(context).pop(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Ver exemplo de erro de pagamento'),
                ),
              ],
            ),
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
