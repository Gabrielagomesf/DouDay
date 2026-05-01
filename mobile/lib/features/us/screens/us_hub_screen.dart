import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

class UsHubScreen extends StatelessWidget {
  const UsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nós'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const maxContentWidth = 600.0;
            final horizontalInset = constraints.maxWidth > maxContentWidth ? (constraints.maxWidth - maxContentWidth) / 2 : 0.0;

            return ListView(
              padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 16),
              children: [
                _Item(
                  icon: Icons.favorite_border,
                  title: 'Check-in',
                  subtitle: 'Como vocês estão hoje',
                  onTap: () => context.push('/checkin'),
                ),
                _Item(
                  icon: Icons.flag_outlined,
                  title: 'Missões',
                  subtitle: 'Gamificação leve do casal',
                  onTap: () => context.push('/missions'),
                ),
                _Item(
                  icon: Icons.note_outlined,
                  title: 'Notas',
                  subtitle: 'Anotações compartilhadas',
                  onTap: () => context.push('/notes'),
                ),
                _Item(
                  icon: Icons.auto_graph,
                  title: 'Resumo semanal',
                  subtitle: 'Evolução e equilíbrio do casal',
                  onTap: () => context.push('/weekly-summary'),
                ),
                _Item(
                  icon: Icons.person_outline,
                  title: 'Perfil do Duo',
                  subtitle: 'Dados do casal e configurações',
                  onTap: () => context.push('/profile'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Item({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

