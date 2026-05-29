/// @file: detalle_materia_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Detalle de una materia para el Alumno. Datos reales.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/attendance_status_chip.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/progress_bar_attendance.dart';
import '../../../core/widgets/section_header.dart';
import '../model/materia_model.dart';
import '../viewmodel/dashboard_alumno_viewmodel.dart';

class DetalleMateriaView extends StatelessWidget {
  const DetalleMateriaView({super.key, required this.materiaId});

  final String materiaId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardAlumnoViewModel()..cargar(),
      child: Consumer<DashboardAlumnoViewModel>(
        builder: (context, vm, child) {
          if (vm.cargando) {
            return Scaffold(
              appBar: AppBar(title: const Text('Materia')),
              body: const LoadingState(),
            );
          }

          final materia = vm.buscar(materiaId);

          return Scaffold(
            appBar: AppBar(
              title: Text(materia?.nombre ?? 'Materia'),
            ),
            floatingActionButton: materia != null
                ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).pushNamed(
                RouteNames.registroAsistencia,
                arguments: {'materiaId': materia.id},
              ),
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Pasar lista'),
            )
                : null,
            body: materia == null
                ? const EmptyState(
              titulo: 'Materia no encontrada',
              icon: Icons.search_off,
            )
                : _Contenido(materia: materia),
          );
        },
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.materia});
  final Materia materia;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingScreen,
      children: [
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                materia.docente,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              AppSpacing.vGapXs,
              Text(
                materia.periodo ?? 'Sin periodo',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.vGapLg,
              ProgressBarAttendance(
                porcentaje: materia.porcentajeAsistencia,
                umbralMinimo: materia.umbralMinimo,
              ),
              AppSpacing.vGapMd,
              _ResumenNumeros(materia: materia),
            ],
          ),
        ),
        AppSpacing.vGapLg,
        // Estatus de derecho a evaluación
        InfoCard(
          child: Row(
            children: [
              Icon(
                materia.cumpleUmbral
                    ? Icons.check_circle
                    : Icons.cancel,
                color: materia.cumpleUmbral
                    ? AppColors.success
                    : AppColors.error,
                size: 28,
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Derecho a evaluación',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    AppSpacing.vGapXs,
                    Text(
                      materia.cumpleUmbral
                          ? 'Tienes derecho — vas con ${(materia.porcentajeAsistencia * 100).toStringAsFixed(0)}%'
                          : 'No alcanzas el ${(materia.umbralMinimo * 100).toStringAsFixed(0)}% requerido',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSpacing.vGapLg,
        if (materia.historial.isNotEmpty) ...[
          const SectionHeader(titulo: 'Historial reciente'),
          AppSpacing.vGapSm,
          ...materia.historial.map(
                (r) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: InfoCard(
                child: Row(
                  children: [
                    AttendanceStatusChip(
                      estado: r.estado,
                      compact: true,
                    ),
                    AppSpacing.hGapMd,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.materia,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${r.fecha.day}/${r.fecha.month}/${r.fecha.year}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AttendanceStatusChip(estado: r.estado),
                  ],
                ),
              ),
            ),
          ),
        ] else
          const EmptyState(
            titulo: 'Sin historial',
            descripcion: 'Aún no hay sesiones registradas para esta materia.',
            icon: Icons.history,
          ),
        AppSpacing.vGapXxl,
      ],
    );
  }
}

class _ResumenNumeros extends StatelessWidget {
  const _ResumenNumeros({required this.materia});
  final Materia materia;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Pill(
          label: 'Asistencias',
          valor: '${materia.asistencias}',
          color: AppColors.asistencia,
        ),
        AppSpacing.hGapSm,
        _Pill(
          label: 'Justificadas',
          valor: '${materia.justificadas}',
          color: AppColors.justificada,
        ),
        AppSpacing.hGapSm,
        _Pill(
          label: 'Faltas',
          valor: '${materia.faltas}',
          color: AppColors.falta,
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.valor,
    required this.color,
  });

  final String label;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}