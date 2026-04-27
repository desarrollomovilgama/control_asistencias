/// =============================================================================
/// info_card.dart
/// -----------------------------------------------------------------------------
/// Tarjeta informativa reutilizable. Apartado 4.2 (Cards) del MPF.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = AppSpacing.paddingCard,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
