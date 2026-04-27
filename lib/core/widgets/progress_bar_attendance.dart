/// =============================================================================
/// progress_bar_attendance.dart
/// -----------------------------------------------------------------------------
/// Barra de progreso de asistencia. RF-03.
/// Cambia de color según el porcentaje respecto a un umbral mínimo.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';
import '../theme/app_colors.dart';

class ProgressBarAttendance extends StatelessWidget {
  const ProgressBarAttendance({
    super.key,
    required this.porcentaje,
    required this.umbralMinimo,
    this.altura = 10,
  });

  /// Valor entre 0.0 y 1.0
  final double porcentaje;

  /// Umbral mínimo de aprobación (0.0 - 1.0). Ej: 0.80 para 80%.
  final double umbralMinimo;

  final double altura;

  Color _color() {
    if (porcentaje >= umbralMinimo) return AppColors.success;
    if (porcentaje >= umbralMinimo - 0.10) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final pct = (porcentaje.clamp(0.0, 1.0) * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: porcentaje.clamp(0.0, 1.0),
            minHeight: altura,
            backgroundColor: AppColors.surfaceVariant,
            color: color,
          ),
        ),
        AppSpacing.vGapXs,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$pct%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              'Mínimo: ${(umbralMinimo * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
