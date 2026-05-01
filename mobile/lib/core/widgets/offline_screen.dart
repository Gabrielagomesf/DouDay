import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class OfflineScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  const OfflineScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.wifi_off, color: Colors.orange, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sem conexão',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Verifique sua internet e tente novamente.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: onRetry, child: const Text('Tentar novamente')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

