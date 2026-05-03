import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_contact_info.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

/// Contacto — só texto na app; copiar e-mail / identificador do site (sem abrir browser).
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void _copy(BuildContext context, String value, String okMsg) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(okMsg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Contato')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Estamos disponíveis pelo e-mail abaixo. Podes copiar e colar na tua app de correio. '
              'O identificador do site é apenas informativo (sem ligação automática à internet).',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 20),
            AppCard(
              onTap: () => _copy(context, AppContactInfo.supportEmail, 'E-mail copiado'),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.mail_outline, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('E-mail de suporte', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        SelectableText(
                          AppContactInfo.supportEmail,
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copiar',
                    onPressed: () => _copy(context, AppContactInfo.supportEmail, 'E-mail copiado'),
                    icon: const Icon(Icons.copy_rounded, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.language, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Identificador do projeto', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        SelectableText(
                          AppContactInfo.siteDisplay,
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Referência interna; não abrimos páginas web a partir da app.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copiar',
                    onPressed: () => _copy(context, AppContactInfo.siteDisplay, 'Texto copiado'),
                    icon: const Icon(Icons.copy_rounded, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Termos e Política de privacidade completos: Configurações → Termos / Política de privacidade.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
