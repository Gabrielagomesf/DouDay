import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Documento legal com texto integral **dentro da app** (scroll + texto selecionável).
/// Se [requireAcceptance] for true, exige aceite antes de fechar com confirmação.
class LegalDocumentScreen extends StatefulWidget {
  final String title;
  final String body;
  final bool requireAcceptance;

  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.body,
    this.requireAcceptance = false,
  });

  @override
  State<LegalDocumentScreen> createState() => _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends State<LegalDocumentScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SelectableText(
                widget.body,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      height: 1.5,
                    ),
              ),
            ),
          ),
          if (widget.requireAcceptance)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CheckboxListTile(
                      value: _accepted,
                      onChanged: (v) => setState(() => _accepted = v ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Li e aceito os termos de uso'),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _accepted
                            ? () {
                                final messenger = ScaffoldMessenger.of(context);
                                Navigator.of(context).pop(true);
                                messenger.showSnackBar(
                                  const SnackBar(content: Text('Aceite registado. Obrigado!')),
                                );
                              }
                            : null,
                        child: const Text('Aceitar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
