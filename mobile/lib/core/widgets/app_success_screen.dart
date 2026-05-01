import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import 'app_page.dart';
import 'app_section_title.dart';

class AppSuccessScreen extends StatelessWidget {
  final String title;
  final String message;
  final String continueLabel;
  final String continueRoute;

  const AppSuccessScreen({
    super.key,
    this.title = 'Tudo certo!',
    required this.message,
    this.continueLabel = 'Continuar',
    required this.continueRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          scroll: false,
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(Icons.check_circle, size: 64, color: AppTheme.success),
              ),
              const SizedBox(height: 24),
              AppSectionTitle(title: title, subtitle: message),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go(continueRoute),
                  child: Text(continueLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

