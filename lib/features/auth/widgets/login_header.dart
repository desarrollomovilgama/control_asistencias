/// =============================================================================
/// login_header.dart
/// -----------------------------------------------------------------------------
/// Encabezado del login (logo + bienvenida).
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.fact_check,
            color: AppColors.textOnPrimary,
            size: 36,
          ),
        ),
        AppSpacing.vGapLg,
        Text('Bienvenido', style: t.displaySmall),
        AppSpacing.vGapXs,
        Text(
          'Ingresa con tu cuenta institucional para registrar tu asistencia '
          'o gestionar tus grupos.',
          style: t.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
