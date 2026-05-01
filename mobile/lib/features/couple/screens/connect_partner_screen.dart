import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/api_client.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_title.dart';

class ConnectPartnerScreen extends ConsumerStatefulWidget {
  const ConnectPartnerScreen({super.key});

  @override
  ConsumerState<ConnectPartnerScreen> createState() => _ConnectPartnerScreenState();
}

class _ConnectPartnerScreenState extends ConsumerState<ConnectPartnerScreen> {
  final _inviteCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isGeneratingCode = false;
  String? _myInviteCode;

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _generateInviteCode() async {
    setState(() => _isGeneratingCode = true);
    
    try {
      final api = ApiClient();
      final response = await api.post('/couples/invite');
      final data = response.data;
      final coupleJson = data is Map<String, dynamic> ? data['couple'] : null;
      final inviteCode = coupleJson is Map<String, dynamic> ? coupleJson['inviteCode'] : null;
      if (inviteCode is! String || inviteCode.isEmpty) {
        throw Exception('Resposta inválida');
      }

      setState(() {
        _myInviteCode = inviteCode;
        _isGeneratingCode = false;
      });
    } catch (e) {
      setState(() => _isGeneratingCode = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao gerar código'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _copyInviteCode() async {
    if (_myInviteCode == null) return;
    await Clipboard.setData(ClipboardData(text: _myInviteCode!));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código copiado')),
      );
    }
  }

  Future<void> _shareInviteCode() async {
    if (_myInviteCode == null) return;
    await Share.share('Meu código DuoDay: ${_myInviteCode!}');
  }

  Future<void> _connectWithPartner() async {
    if (_inviteCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o código do seu parceiro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final api = ApiClient();
      await api.post('/couples/connect', data: {
        'inviteCode': _inviteCodeController.text.trim(),
      });

      // Refresh local user profile to update coupleId/partner
      final authService = ref.read(authServiceProvider);
      await authService.refreshUserProfile();
      
      if (mounted) {
        context.go('/connection-success');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código inválido ou expirado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar com parceiro'),
      ),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.primary.withValues(alpha: 0.20),
                        scheme.secondary.withValues(alpha: 0.14),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
                  ),
                  child: Icon(Icons.favorite, color: scheme.primary, size: 56),
                ),
              ),

              const SizedBox(height: 18),

              const AppSectionTitle(
                title: 'Conecte-se com seu parceiro',
                subtitle: 'Gere um convite ou digite o código do seu parceiro para unir as contas.',
              ),

              const SizedBox(height: 16),

              if (_myInviteCode != null) ...[
                AppCard(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: AppTheme.success, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'Seu código de convite',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: scheme.primary.withValues(alpha: 0.16)),
                        ),
                        child: Text(
                          _myInviteCode!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _copyInviteCode,
                              icon: const Icon(Icons.copy),
                              label: const Text('Copiar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _shareInviteCode,
                              icon: const Icon(Icons.share),
                              label: const Text('Compartilhar'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Status: aguardando parceiro • expira em 24h',
                        style: TextStyle(color: AppTheme.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isGeneratingCode ? null : _generateInviteCode,
                    icon: _isGeneratingCode
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.qr_code),
                    label: Text(_isGeneratingCode ? 'Gerando...' : 'Gerar meu código'),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Divider(color: scheme.onSurface.withValues(alpha: 0.14))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OU',
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: scheme.onSurface.withValues(alpha: 0.14))),
                  ],
                ),
                const SizedBox(height: 18),
              ],

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Digitar código do parceiro',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _inviteCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Código do parceiro',
                        prefixIcon: Icon(Icons.vpn_key_outlined),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Peça para seu parceiro gerar o código e digite aqui.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withValues(alpha: 0.7),
                          ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _connectWithPartner,
                        style: FilledButton.styleFrom(backgroundColor: AppTheme.heart),
                        child: _isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text(
                                'Conectar',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                      ),
                    ),
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
