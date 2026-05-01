import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/onboarding_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingServiceProvider).markCompleted();
    if (mounted) context.go('/login');
  }

  void _next() {
    if (_index >= 2) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.primary.withValues(alpha: 0.08),
                      scheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            AppPage(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              scroll: false,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: _finish,
                        child: const Text('Pular'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (i) => setState(() => _index = i),
                      children: const [
                        _OnboardingPage(
                          title: 'Tudo do casal em um só lugar',
                          body: 'Tarefas, contas, agenda e lembretes compartilhados.',
                          icon: Icons.dashboard_customize_outlined,
                        ),
                        _OnboardingPage(
                          title: 'Conecte seu parceiro',
                          body: 'Convide a pessoa para dividir a rotina com você.',
                          icon: Icons.link_outlined,
                        ),
                        _OnboardingPage(
                          title: 'Mais parceria, menos estresse',
                          body: 'Acompanhe responsabilidades e mantenha a rotina mais leve.',
                          icon: Icons.favorite_border,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _index == i ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _index == i ? AppTheme.primaryColor : AppTheme.primaryColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(_index == 2 ? 'Começar agora' : 'Próximo'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(icon, size: 56, color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

