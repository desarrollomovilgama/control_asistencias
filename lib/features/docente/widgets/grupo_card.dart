/// @file: grupo_card.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Tarjeta de grupo en la lista del docente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../model/grupo_model.dart';

class GrupoCard extends StatelessWidget {
  const GrupoCard({super.key, required this.grupo, required this.onTap});

  final Grupo grupo;
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
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.groups, color: AppColors.primary),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(grupo.nombre, style: t.titleMedium),
                AppSpacing.vGapXs,
                Text(
                  '${grupo.alumnosCount} alumno(s) · ${grupo.periodoAcademico}',
                  style: t.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  'Umbral: ${grupo.umbralMinimo}%',
                  style: t.bodySmall?.copyWith(color: AppColors.textHint),
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