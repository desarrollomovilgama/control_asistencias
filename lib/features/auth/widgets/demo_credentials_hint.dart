/// =============================================================================
/// demo_credentials_hint.dart
/// -----------------------------------------------------------------------------
/// Banner informativo con las credenciales DEMO disponibles.
/// Solo visible en modo maqueta.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class DemoCredentialsHint extends StatelessWidget {
  const DemoCredentialsHint({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 18),
              AppSpacing.hGapSm,
              Text(
                'Credenciales DEMO',
                style: t.labelLarge?.copyWith(color: AppColors.info),
              ),
            ],
          ),
          AppSpacing.vGapSm,
          Text('alumno@itt.edu.mx · demo1234', style: t.bodySmall),
          Text('docente@itt.edu.mx · demo1234', style: t.bodySmall),
          Text('docente@universidad.mx · demo1234', style: t.bodySmall),
        ],
      ),
    );
  }
}
