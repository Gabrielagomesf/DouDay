import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/onboarding_service.dart';
import '../../../core/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 900));

    final authService = ref.read(authServiceProvider);
    await authService.loadStoredCredentials();
    final onboardingCompleted = await ref.read(onboardingServiceProvider).isCompleted();

    if (mounted) {
      if (!onboardingCompleted) {
        context.go('/onboarding');
        return;
      }
      context.go(authService.isAuthenticated ? '/home' : '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryGradientStart,
                  AppTheme.primaryGradientEnd,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppTheme.primaryColor,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'DuoDay',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Organize sua vida a dois',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 180,
                  child: Image.asset(
                    'assets/images/splash_couple.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.groups_2_rounded,
                      size: 120,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
