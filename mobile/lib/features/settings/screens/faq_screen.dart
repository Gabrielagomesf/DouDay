import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

/// Perguntas frequentes (conteúdo informativo).
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const List<({String q, String a})> _items = [
    (
      q: 'O DuoDay é gratuito?',
      a: 'Sim, podes usar as funções principais sem custo. Funcionalidades premium podem ser acrescentadas no futuro.',
    ),
    (
      q: 'Como conecto com o meu parceiro?',
      a: 'Em Configurações ou no fluxo inicial, usa “Conectar parceiro”: gera um código ou insere o código que o teu parceiro te enviou. Ambos precisam de conta.',
    ),
    (
      q: 'Os dados são partilhados com o parceiro?',
      a: 'As tarefas, agenda, finanças e check-ins do casal são visíveis dentro do vosso Duo, conforme descrito na Política de privacidade.',
    ),
    (
      q: 'Posso usar sem internet?',
      a: 'É necessária ligação para sincronizar com o servidor. Sem rede, o que já estiver em cache pode aparecer limitado.',
    ),
    (
      q: 'Como apago a minha conta?',
      a: 'Contacta o suporte pelo e-mail em Contato ou segue as instruções no site, conforme a lei aplicável e a nossa política.',
    ),
    (
      q: 'Onde leio os Termos e a Privacidade?',
      a: 'Em Configurações → Termos de uso e Política de privacidade. Também podes abrir a versão completa no navegador.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Perguntas frequentes')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Respostas rápidas sobre o DuoDay. Para documentos oficiais, usa Termos e Política nas Configurações.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 16),
            ..._items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: AppTheme.surface,
                    collapsedBackgroundColor: AppTheme.surface,
                    title: Text(item.q, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item.a, style: const TextStyle(color: AppTheme.textSecondary, height: 1.45)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => context.push('/settings/contact'),
              icon: const Icon(Icons.mail_outline, size: 20),
              label: const Text('Ainda tens dúvidas? Contato'),
            ),
          ],
        ),
      ),
    );
  }
}
