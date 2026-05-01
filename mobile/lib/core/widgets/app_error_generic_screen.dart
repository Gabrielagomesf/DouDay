import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import 'app_page.dart';
import 'app_section_title.dart';

class AppErrorGenericScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? backRoute;

  const AppErrorGenericScreen({
    super.key,
    this.title = 'Ops! Algo deu errado',
    required this.message,
    this.onRetry,
    this.backRoute,
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
                  color: AppTheme.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(Icons.error_outline, size: 64, color: AppTheme.warning),
              ),
              const SizedBox(height: 24),
              AppSectionTitle(title: title, subtitle: message),
              const Spacer(),
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Tentar novamente', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              if (backRoute != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => context.go(backRoute!),
                    child: const Text('Voltar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

