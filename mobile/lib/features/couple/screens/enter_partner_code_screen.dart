import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/api_client.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_title.dart';

class EnterPartnerCodeScreen extends ConsumerStatefulWidget {
  const EnterPartnerCodeScreen({super.key});

  @override
  ConsumerState<EnterPartnerCodeScreen> createState() => _EnterPartnerCodeScreenState();
}

class _EnterPartnerCodeScreenState extends ConsumerState<EnterPartnerCodeScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite o código do seu parceiro')));
      return;
    }

    setState(() => _loading = true);
    try {
      final api = ApiClient();
      await api.post('/couples/connect', data: {'inviteCode': _controller.text.trim()});
      final authService = ref.read(authServiceProvider);
      await authService.refreshUserProfile();
      if (!mounted) return;
      context.go('/connection-success');
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código inválido ou expirado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inserir código do parceiro')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const AppSectionTitle(
                title: 'Inserir código do parceiro',
                subtitle: 'Digite o código do Duo que seu parceiro criou.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 2),
                decoration: const InputDecoration(
                  labelText: 'Código',
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _connect,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text(
                          'Conectar',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Como funciona?', style: TextStyle(fontWeight: FontWeight.w800)),
                    SizedBox(height: 10),
                    Text('1. Peça para seu parceiro criar um Duo', style: TextStyle(color: AppTheme.textSecondary)),
                    SizedBox(height: 6),
                    Text('2. Ele envia o código', style: TextStyle(color: AppTheme.textSecondary)),
                    SizedBox(height: 6),
                    Text('3. Você insere o código aqui', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

