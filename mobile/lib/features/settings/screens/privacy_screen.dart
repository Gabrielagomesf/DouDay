import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

/// Resumo de privacidade + atalho para a política completa **na app** (sem browser).
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Privacidade')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionTitle('Dados coletados'),
            const SizedBox(height: 8),
            const Text(
              'Podemos coletar dados de conta (nome, e-mail), dados de uso do aplicativo e informações que você '
              'voluntariamente registra (tarefas, finanças, check-ins), sempre para prestar o serviço do DuoDay.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            _SectionTitle('Uso dos dados'),
            const SizedBox(height: 8),
            const Text(
              'Os dados são usados para sincronizar a experiência do casal, enviar lembretes, melhorar o produto '
              'e cumprir obrigações legais. Não vendemos seus dados pessoais.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            _SectionTitle('Segurança'),
            const SizedBox(height: 8),
            const Text(
              'Adotamos boas práticas de segurança e criptografia em trânsito quando aplicável. '
              'Nenhum sistema é 100% invulnerável — use senha forte e não partilhe o acesso.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            _SectionTitle('Exclusão de conta'),
            const SizedBox(height: 8),
            const Text(
              'Pode solicitar a exclusão ou o exercício dos seus direitos RGPD através do e-mail em Contato. '
              'Alguns registros podem ser mantidos pelo tempo necessário para obrigações legais.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 28),
            AppCard(
              onTap: () => context.push('/settings/privacy-policy'),
              child: Row(
                children: [
                  const Icon(Icons.article_outlined, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Política de privacidade completa', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text('Ler todo o texto na app', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
    );
  }
}
