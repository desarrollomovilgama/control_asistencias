/// =============================================================================
/// detalle_alumno_asistencia_view.dart
/// -----------------------------------------------------------------------------
/// Vista para que el docente consulte y modifique el historial detallado de un alumno.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/attendance_status_chip.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../alumno/model/materia_model.dart';
import '../model/grupo_model.dart';

class DetalleAlumnoAsistenciaView extends StatefulWidget {
  const DetalleAlumnoAsistenciaView({super.key, required this.alumno});

  final AlumnoGrupo alumno;

  @override
  State<DetalleAlumnoAsistenciaView> createState() =>
      _DetalleAlumnoAsistenciaViewState();
}

class _DetalleAlumnoAsistenciaViewState
    extends State<DetalleAlumnoAsistenciaView> {
  late List<RegistroAsistencia> _historial;

  @override
  void initState() {
    super.initState();
    _historial = List.from(widget.alumno.historial);
  }

  void _cambiarEstado(int index, EstadoAsistencia nuevoEstado) {
    setState(() {
      final registro = _historial[index];
      _historial[index] = RegistroAsistencia(
        fecha: registro.fecha,
        estado: nuevoEstado,
        nota: registro.nota,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Estado actualizado a ${nuevoEstado.name} (simulado)'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asistencias =
        _historial.where((r) => r.estado == EstadoAsistencia.asistencia).length;
    final justificadas =
        _historial.where((r) => r.estado == EstadoAsistencia.justificada).length;
    final faltas =
        _historial.where((r) => r.estado == EstadoAsistencia.falta).length;
    final total = _historial.length;
    final porcentaje = total == 0 ? 0.0 : (asistencias + justificadas) / total;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de asistencia')),
      body: ListView(
        padding: AppSpacing.paddingScreen,
        children: [
          InfoCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(widget.alumno.nombre.substring(0, 1)),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.alumno.nombre,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Matrícula: ${widget.alumno.matricula}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.vGapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Estadistica(
                label: 'Asistencias',
                valor: asistencias.toString(),
                color: AppColors.asistencia,
              ),
              _Estadistica(
                label: 'Justificadas',
                valor: justificadas.toString(),
                color: AppColors.justificada,
              ),
              _Estadistica(
                label: 'Faltas',
                valor: faltas.toString(),
                color: AppColors.falta,
              ),
              _Estadistica(
                label: 'Porcentaje',
                valor: '${(porcentaje * 100).toStringAsFixed(0)}%',
                color: AppColors.primary,
              ),
            ],
          ),
          AppSpacing.vGapLg,
          const SectionHeader(
            titulo: 'Historial de sesiones',
            subtitulo: 'Toca un registro para cambiar su estado.',
          ),
          AppSpacing.vGapSm,
          ...List.generate(_historial.length, (i) {
            final r = _historial[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: InfoCard(
                onTap: () => _mostrarOpcionesEstado(context, i, r.estado),
                child: Row(
                  children: [
                    AttendanceStatusChip(estado: r.estado, compact: true),
                    AppSpacing.hGapMd,
                    Text(
                      '${r.fecha.day}/${r.fecha.month}/${r.fecha.year}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    const Icon(Icons.edit_outlined,
                        size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _mostrarOpcionesEstado(
      BuildContext context, int index, EstadoAsistencia actual) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle, color: AppColors.asistencia),
              title: const Text('Asistencia'),
              trailing: actual == EstadoAsistencia.asistencia
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                _cambiarEstado(index, EstadoAsistencia.asistencia);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: AppColors.falta),
              title: const Text('Falta'),
              trailing: actual == EstadoAsistencia.falta
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                _cambiarEstado(index, EstadoAsistencia.falta);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_available,
                  color: AppColors.justificada),
              title: const Text('Justificada'),
              trailing: actual == EstadoAsistencia.justificada
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                _cambiarEstado(index, EstadoAsistencia.justificada);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Estadistica extends StatelessWidget {
  const _Estadistica({
    required this.label,
    required this.valor,
    required this.color,
  });

  final String label;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
