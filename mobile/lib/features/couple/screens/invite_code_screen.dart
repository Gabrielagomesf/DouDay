import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/api_client.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_title.dart';

class InviteCodeScreen extends ConsumerStatefulWidget {
  const InviteCodeScreen({super.key});

  @override
  ConsumerState<InviteCodeScreen> createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends ConsumerState<InviteCodeScreen> {
  bool _loading = false;
  String? _code;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    setState(() => _loading = true);
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
        _code = inviteCode;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao gerar código')));
    }
  }

  Future<void> _copy() async {
    if (_code == null) return;
    await Clipboard.setData(ClipboardData(text: _code!));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código copiado')));
  }

  Future<void> _share() async {
    if (_code == null) return;
    await Share.share('Meu código DuoDay: ${_code!}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seu código de convite')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const AppSectionTitle(
                title: 'Seu código de convite',
                subtitle: 'Envie esse código para seu parceiro entrar no Duo.',
              ),
              const SizedBox(height: 16),
              if (_loading)
                const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else
                AppCard(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _code ?? '—',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Validade do código: 24 horas', style: TextStyle(color: AppTheme.textSecondary)),
                      const SizedBox(height: 6),
                      const Text(
                        'Status: Aguardando parceiro se conectar...',
                        style: TextStyle(color: AppTheme.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _copy,
                              child: const Text('Copiar código'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _share,
                              child: const Text('Compartilhar'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _generate,
                          child: const Text(
                            'Gerar novo código',
                            style: TextStyle(fontWeight: FontWeight.w700),
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

