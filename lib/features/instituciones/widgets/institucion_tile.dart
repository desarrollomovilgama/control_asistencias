/// @file: institucion_tile.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Tarjeta de institución del docente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
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
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                institucion.inicial,
                style: t.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Text(institucion.nombre, style: t.titleMedium),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textHint),
        ],
      ),
    );
  }
}