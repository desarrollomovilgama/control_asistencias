/// =============================================================================
/// institucion_tile.dart
/// -----------------------------------------------------------------------------
/// Tarjeta de selección de institución (RF-04).
/// Muestra logo (o iniciales), nombre y conteo de rubros configurados.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../model/institucion_model.dart';

class InstitucionTile extends StatelessWidget {
  const InstitucionTile({
    super.key,
    required this.institucion,
    required this.onTap,
  });

  final Institucion institucion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InfoCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: institucion.colorPrimario.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                institucion.nombre.substring(0, 1),
                style: t.headlineMedium?.copyWith(
                  color: institucion.colorPrimario,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(institucion.nombre, style: t.titleMedium),
                AppSpacing.vGapXs,
                Text(
                  '${institucion.rubros.length} rubro(s) configurado(s)',
                  style: t.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textHint),
        ],
      ),
    );
  }
}
