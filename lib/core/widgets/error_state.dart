/// =============================================================================
/// error_state.dart
/// -----------------------------------------------------------------------------
/// Estado de error estándar con botón de reintento. Apartado 4.2 (UX) del MPF.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';
import '../theme/app_colors.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.mensaje,
    this.onRetry,
  });

  final String mensaje;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: AppSpacing.paddingScreen,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.vGapMd,
            Text(
              mensaje,
              style: t.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.vGapLg,
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
