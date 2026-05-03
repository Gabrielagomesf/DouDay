import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Estados de sucesso / erro (doc): ícone, mensagem, ação e espaço para ilustração.
class AppFeedbackPage extends StatelessWidget {
  final bool success;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? assetImagePath;

  const AppFeedbackPage({
    super.key,
    required this.success,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.assetImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              if (assetImagePath != null)
                SizedBox(
                  height: 160,
                  child: Image.asset(assetImagePath!, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                            success ? Icons.check_circle : Icons.error_outline,
                            size: 88,
                            color: success ? AppTheme.success : AppTheme.error,
                          )),
                )
              else
                Icon(
                  success ? Icons.check_circle : Icons.error_outline,
                  size: 88,
                  color: success ? AppTheme.success : AppTheme.error,
                ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary, height: 1.45),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onPrimary,
                  child: Text(primaryLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
