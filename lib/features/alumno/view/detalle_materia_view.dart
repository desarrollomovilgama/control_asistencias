/// =============================================================================
/// detalle_materia_view.dart
/// -----------------------------------------------------------------------------
/// Detalle de una materia para el Alumno.
/// Muestra progreso e historial de asistencia (Solo lectura).
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/attendance_status_chip.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/progress_bar_attendance.dart';
import '../../../core/widgets/section_header.dart';
import '../../instituciones/model/institucion_model.dart';
import '../model/materia_model.dart';
import '../viewmodel/dashboard_alumno_viewmodel.dart';
import '../widgets/estatus_rubro_card.dart';

class DetalleMateriaView extends StatelessWidget {
  const DetalleMateriaView({super.key, required this.materiaId});

  final String materiaId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardAlumnoViewModel()..cargar(),
      child: Consumer<DashboardAlumnoViewModel>(
        builder: (context, vm, child) {
          final materia = vm.buscar(materiaId);
          return Scaffold(
            appBar: AppBar(
              title: Text(materia?.nombre ?? 'Materia'),
              actions: [
                if (materia != null)
                  IconButton(
                    icon: const Icon(Icons.vpn_key_outlined),
                    tooltip: 'Código de clase',
                    onPressed: () => _mostrarCodigo(context, materia),
                  ),
              ],
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

  void _mostrarCodigo(BuildContext context, Materia materia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Código de clase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Comparte este código para que otros se unan:'),
            AppSpacing.vGapMd,
            SelectableText(
              materia.codigoMateria,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: materia.codigoMateria));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código copiado')),
              );
              Navigator.pop(context);
            },
            child: const Text('Copiar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  const _Contenido({required this.materia});
  final Materia materia;

  List<RubroEvaluacion> _rubrosDe(Materia m) {
    if (m.institucion == InstitucionesDemo.tec.nombre) {
      return InstitucionesDemo.tec.rubros;
    }
    return InstitucionesDemo.universidad.rubros;
  }

  @override
  Widget build(BuildContext context) {
    final rubros = _rubrosDe(materia);
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
              Text(
                materia.institucion,
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
        const SectionHeader(titulo: 'Estatus por rubro'),
        AppSpacing.vGapSm,
        ...rubros.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: EstatusRubroCard(
              rubro: r,
              porcentajeActual: materia.porcentajeAsistencia,
            ),
          ),
        ),
        AppSpacing.vGapLg,
        const SectionHeader(titulo: 'Historial reciente'),
        AppSpacing.vGapSm,
        ...materia.historial.map(
          (r) => InfoCard(
            child: Row(
              children: [
                AttendanceStatusChip(estado: r.estado, compact: true),
                AppSpacing.hGapMd,
                Expanded(
                  child: Text(
                    '${r.fecha.day}/${r.fecha.month}/${r.fecha.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                // Botón de justificar eliminado. El alumno solo consulta su estado.
              ],
            ),
          ),
        ),
        AppSpacing.vGapXxl,
      ].expand((w) => [w, AppSpacing.vGapXs]).toList(),
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
