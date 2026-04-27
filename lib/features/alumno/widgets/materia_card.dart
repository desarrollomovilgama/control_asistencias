/// =============================================================================
/// materia_card.dart
/// -----------------------------------------------------------------------------
/// Tarjeta de materia en el dashboard del alumno (RF-03).
/// Muestra nombre, docente, barra de progreso y mini-historial coloreado.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/attendance_status_chip.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/progress_bar_attendance.dart';
import '../model/materia_model.dart';

class MateriaCard extends StatelessWidget {
  const MateriaCard({
    super.key,
    required this.materia,
    required this.onTap,
  });

  final Materia materia;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InfoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(materia.nombre, style: t.titleMedium),
                    AppSpacing.vGapXs,
                    Text(
                      '${materia.docente} · ${materia.institucion}',
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
          AppSpacing.vGapMd,
          ProgressBarAttendance(
            porcentaje: materia.porcentajeAsistencia,
            umbralMinimo: materia.umbralMinimo,
          ),
          AppSpacing.vGapMd,
          Row(
            children: materia.historial
                .take(8)
                .map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: AttendanceStatusChip(
                      estado: r.estado,
                      compact: true,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
