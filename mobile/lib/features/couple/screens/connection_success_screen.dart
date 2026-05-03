import 'package:flutter/material.dart';

import '../../../core/widgets/app_success_screen.dart';

class ConnectionSuccessScreen extends StatelessWidget {
  const ConnectionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSuccessScreen(
      title: 'Duo criado com sucesso',
      message: 'Agora vocês podem organizar a rotina juntos.',
      continueLabel: 'Ir para o app',
      continueRoute: '/home',
    );
  }
}

