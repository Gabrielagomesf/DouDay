import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxContentWidth;
  final bool scroll;

  const AppPage({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    this.maxContentWidth = 600,
    this.scroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalInset = constraints.maxWidth > maxContentWidth
            ? ((constraints.maxWidth - maxContentWidth) / 2)
            : 0.0;

        final effectivePadding = padding.add(EdgeInsets.symmetric(horizontal: horizontalInset));

        if (!scroll) {
          return Padding(
            padding: effectivePadding,
            child: child,
          );
        }

        return ListView(
          padding: effectivePadding,
          children: [child],
        );
      },
    );
  }
}

