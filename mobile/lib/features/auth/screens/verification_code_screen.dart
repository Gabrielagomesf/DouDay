import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_title.dart';

class VerificationCodeScreen extends ConsumerStatefulWidget {
  final String email;
  const VerificationCodeScreen({super.key, required this.email});

  @override
  ConsumerState<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends ConsumerState<VerificationCodeScreen> {
  final _codeController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 5 * 60;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_remainingSeconds <= 0) return;
      setState(() => _remainingSeconds -= 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  String get _maskedEmail {
    final email = widget.email.trim();
    final at = email.indexOf('@');
    if (at <= 1) return email;
    final name = email.substring(0, at);
    final domain = email.substring(at);
    final visible = name.substring(0, 1);
    return '$visible***$domain';
  }

  String get _countdown {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _verify() async {
    final code = _codeController.text.replaceAll(RegExp(r'\D'), '');
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um código de 6 dígitos')),
      );
      return;
    }
    try {
      await ref.read(authServiceProvider).verifyResetCode(
            email: widget.email,
            code: code,
          );
      if (!mounted) return;
      context.go('/new-password', extra: {'email': widget.email});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Código inválido ou expirado: $e')));
    }
  }

  Future<void> _resend() async {
    setState(() => _remainingSeconds = 5 * 60);
    try {
      await ref.read(authServiceProvider).forgotPassword(widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código reenviado')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Falha ao reenviar código: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digite o código')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              AppSectionTitle(
                title: 'Digite o código',
                subtitle: 'Enviamos um código para $_maskedEmail',
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Código de 6 dígitos',
                  prefixIcon: Icon(Icons.lock_outline),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Expira em $_countdown',
                    style: const TextStyle(color: AppTheme.textSecondary),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _resend,
                    child: Text(
                      'Reenviar código',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _verify,
                  child: const Text(
                    'Verificar código',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

