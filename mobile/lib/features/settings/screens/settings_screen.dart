import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Tile(
              icon: Icons.person_outline,
              title: 'Dados da conta',
              onTap: () => context.push('/profile'),
            ),
            _Tile(
              icon: Icons.notifications_outlined,
              title: 'Notificações',
              onTap: () => context.push('/settings/notifications'),
            ),
            _Tile(
              icon: Icons.palette_outlined,
              title: 'Aparência',
              onTap: () => context.push('/settings/appearance'),
            ),
            _Tile(
              icon: Icons.lock_outline,
              title: 'Segurança',
              onTap: () => context.push('/security'),
            ),
            _Tile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacidade',
              onTap: () => context.push('/settings/privacy'),
            ),
            _Tile(
              icon: Icons.gavel_outlined,
              title: 'Termos de uso',
              onTap: () => context.push('/settings/terms'),
            ),
            _Tile(
              icon: Icons.policy_outlined,
              title: 'Política de privacidade',
              onTap: () => context.push('/settings/privacy-policy'),
            ),
            _Tile(
              icon: Icons.help_outline,
              title: 'Perguntas frequentes (FAQ)',
              onTap: () => context.push('/settings/faq'),
            ),
            _Tile(
              icon: Icons.mail_outline,
              title: 'Contato',
              onTap: () => context.push('/settings/contact'),
            ),
            _Tile(
              icon: Icons.info_outline,
              title: 'Sobre o DuoDay',
              onTap: () => context.push('/settings/about'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error, foregroundColor: Colors.white),
              onPressed: () async {
                await ref.read(authServiceProvider).logout();
                if (context.mounted) context.go('/login');
              },
              child: const Text('Sair da conta'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _Tile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
