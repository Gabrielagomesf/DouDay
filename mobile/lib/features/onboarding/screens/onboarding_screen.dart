import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/onboarding_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_page.dart';

/// Onboarding em 5 passos (doc DuoDay): 4 telas + ecrã final “Comece seu Duo”.
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

  Future<void> _markAndGo(String path) async {
    await ref.read(onboardingServiceProvider).markCompleted();
    if (mounted) context.go(path);
  }

  void _next() {
    if (_index >= 4) return;
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          scroll: false,
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => _markAndGo('/login'),
                    child: Text(
                      'Pular',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: const [
                    _OnboardingPage(
                      title: 'Organize sua vida a dois',
                      body:
                          'Tarefas, agenda, finanças e momentos do casal em um só lugar.',
                      icon: Icons.dashboard_customize_outlined,
                      illustrationAsset: 'assets/images/onboarding_1.png',
                    ),
                    _OnboardingPage(
                      title: 'Tudo mais leve e organizado',
                      body: 'Divida tarefas, acompanhe compromissos e reduza esquecimentos.',
                      icon: Icons.smartphone_rounded,
                      illustrationAsset: 'assets/images/onboarding_2.png',
                    ),
                    _OnboardingPage(
                      title: 'Mais parceria no dia a dia',
                      body: 'Criem uma rotina mais equilibrada, com diálogo e colaboração.',
                      icon: Icons.favorite_border_rounded,
                      illustrationAsset: 'assets/images/onboarding_3.png',
                    ),
                    _OnboardingPage(
                      title: 'Conquistem juntos',
                      body: 'Acompanhem metas, planos e pequenas vitórias.',
                      icon: Icons.celebration_outlined,
                      illustrationAsset: 'assets/images/onboarding_4.png',
                    ),
                    _OnboardingActionPage(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _index == i ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _index == i ? AppTheme.primaryColor : AppTheme.primaryColor.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_index < 4)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _next,
                    child: const Text('Próximo'),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _markAndGo('/register'),
                        child: const Text('Criar conta'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => _markAndGo('/login'),
                        child: const Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;
  final String illustrationAsset;

  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.icon,
    required this.illustrationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          child: Image.asset(
            illustrationAsset,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(icon, size: 64, color: AppTheme.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.45,
              ),
        ),
      ],
    );
  }
}

class _OnboardingActionPage extends StatelessWidget {
  const _OnboardingActionPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          child: Image.asset(
            'assets/images/onboarding_4.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.rocket_launch_rounded, size: 64, color: AppTheme.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Comece seu Duo',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Convide seu parceiro e organize a vida de vocês juntos.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.45,
              ),
        ),
      ],
    );
  }
}
