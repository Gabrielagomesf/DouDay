import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_card.dart';

/// Tela “Nós” (doc): tempo juntos, avatares, cards emocionais e rotinas.
class CoupleHubScreen extends ConsumerWidget {
  const CoupleHubScreen({super.key});

  static String _togetherLabel(DateTime? since) {
    if (since == null) return 'Começando agora o Duo';
    final now = DateTime.now();
    final d = DateTime(now.year, now.month, now.day).difference(DateTime(since.year, since.month, since.day)).inDays;
    if (d <= 0) return 'Primeiros dias juntos';
    final years = d ~/ 365;
    final months = (d % 365) ~/ 30;
    final days = d % 30;
    final parts = <String>[];
    if (years > 0) parts.add('$years ${years == 1 ? 'ano' : 'anos'}');
    if (months > 0) parts.add('$months ${months == 1 ? 'mês' : 'meses'}');
    if (years == 0 && months == 0) parts.add('$d ${d == 1 ? 'dia' : 'dias'}');
    else if (days > 0 && years == 0) parts.add('$days dias');
    return 'Juntos há ${parts.join(', ')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    final partnerName =
        (user?.partnerName?.trim().isNotEmpty ?? false) ? user!.partnerName!.trim() : 'Parceiro(a)';
    final myName = (user?.name.trim().isNotEmpty ?? false) ? user!.name.trim() : 'Eu';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Nós'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const maxContentWidth = 600.0;
            final horizontalInset =
                constraints.maxWidth > maxContentWidth ? (constraints.maxWidth - maxContentWidth) / 2 : 0.0;

            return ListView(
              padding: EdgeInsets.fromLTRB(16 + horizontalInset, 16, 16 + horizontalInset, 24),
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/hub_couple.png',
                      height: 140,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox(height: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _togetherLabel(user?.createdAt),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.12),
                      child: Text(
                        myName.isNotEmpty ? myName[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.primaryColor),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.favorite, color: AppTheme.accentPink, size: 28),
                    ),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.accentPink.withValues(alpha: 0.15),
                      child: Text(
                        partnerName.isNotEmpty ? partnerName[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppTheme.accentPink),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$myName · $partnerName',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                _Tile(
                  icon: Icons.favorite_border,
                  title: 'Check-in',
                  subtitle: 'Como vocês estão hoje',
                  onTap: () => context.push('/checkin'),
                ),
                _Tile(
                  icon: Icons.flag_outlined,
                  title: 'Metas',
                  subtitle: 'Conquistem objetivos juntos',
                  onTap: () => context.push('/goals'),
                ),
                _Tile(
                  icon: Icons.photo_library_outlined,
                  title: 'Momentos',
                  subtitle: 'Notas e lembranças compartilhadas',
                  onTap: () => context.push('/notes'),
                ),
                _Tile(
                  icon: Icons.emoji_events_outlined,
                  title: 'Conquistas',
                  subtitle: 'Missões e vitórias do casal',
                  onTap: () => context.push('/missions'),
                ),
                _Tile(
                  icon: Icons.auto_graph,
                  title: 'Resumo semanal',
                  subtitle: 'Tarefas, contas e humor da semana',
                  onTap: () => context.push('/weekly-summary'),
                ),
                _Tile(
                  icon: Icons.person_outline,
                  title: 'Perfil',
                  subtitle: 'Dados e configurações',
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

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile({
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
