import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_page.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    setState(() => _saving = true);
    try {
      await ref.read(authServiceProvider).changePassword(
            currentPassword: _current.text,
            newPassword: _next.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha alterada')));
      }
      _current.clear();
      _next.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _soon(String title) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            const Text(
              'Estamos preparando esta área: lista de dispositivos, encerramento remoto de sessões e auditoria de acesso.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segurança'),
      ),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppCard(
                child: Column(
                  children: [
                    _SecurityTile(
                      title: 'Ver dispositivos conectados',
                      onTap: () => _soon('Dispositivos conectados'),
                    ),
                    const Divider(height: 20),
                    _SecurityTile(
                      title: 'Encerrar todas as sessões',
                      onTap: () => _soon('Encerrar sessões'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Alterar senha', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _current,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha atual'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _next,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Nova senha'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _changePassword,
                        child: Text(_saving ? 'Salvando...' : 'Alterar senha'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.go('/connect-partner'),
                        child: const Text('Desconectar parceiro'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Excluir conta'),
                              content: const Text(
                                'Esta ação é irreversível e removerá seus dados em definitivo quando o backend suportar exclusão.',
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Em breve: exclusão integral da conta')),
                                    );
                                  },
                                  child: const Text('Continuar'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Excluir conta'),
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

class _SecurityTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SecurityTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
