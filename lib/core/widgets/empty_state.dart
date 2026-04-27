/// =============================================================================
/// empty_state.dart
/// -----------------------------------------------------------------------------
/// Estado vacío estándar (lista sin resultados). Apartado 4.2 (UX) del MPF.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';
import '../theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.titulo,
    this.descripcion,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String titulo;
  final String? descripcion;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: AppSpacing.paddingScreen,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textHint),
            AppSpacing.vGapMd,
            Text(
              titulo,
              style: t.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (descripcion != null) ...[
              AppSpacing.vGapSm,
              Text(
                descripcion!,
                style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.vGapLg,
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
