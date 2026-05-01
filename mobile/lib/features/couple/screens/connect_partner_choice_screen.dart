import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_section_title.dart';

class ConnectPartnerChoiceScreen extends StatelessWidget {
  const ConnectPartnerChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conectar parceiro')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const AppSectionTitle(
                title: 'Vamos conectar vocês dois!',
                subtitle: 'Escolha como criar o Duo e começar a dividir a rotina.',
              ),
              const SizedBox(height: 18),
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/connect-partner/invite'),
                  child: const Text(
                    'Criar meu Duo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.go('/connect-partner/enter'),
                  child: const Text(
                    'Inserir código do parceiro',
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

