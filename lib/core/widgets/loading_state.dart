/// =============================================================================
/// loading_state.dart
/// -----------------------------------------------------------------------------
/// Indicador de carga estándar. RF-16 (Indicadores de carga).
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';
import '../theme/app_colors.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.mensaje});

  final String? mensaje;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (mensaje != null) ...[
            AppSpacing.vGapMd,
            Text(
              mensaje!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
