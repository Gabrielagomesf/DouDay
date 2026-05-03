import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_page.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((i) => setState(() => _info = i));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o DuoDay')),
      body: SafeArea(
        child: AppPage(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.favorite, size: 44, color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _info?.appName ?? 'DuoDay',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                _info != null ? 'Versão ${_info!.version} (${_info!.buildNumber})' : 'Carregando versão…',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              const Text(
                'DuoDay ajuda casais a organizarem tarefas, finanças, agenda e bem-estar em um só lugar.',
                style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
