/// @file: historial_asistencias_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Historial de asistencias del alumno. Datos reales desde Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/attendance_status_chip.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../services/alumno_service.dart';
import '../model/materia_model.dart';

class HistorialAsistenciasView extends StatefulWidget {
  const HistorialAsistenciasView({super.key});

  @override
  State<HistorialAsistenciasView> createState() =>
      _HistorialAsistenciasViewState();
}

class _HistorialAsistenciasViewState extends State<HistorialAsistenciasView> {
  List<RegistroAsistencia> _historial = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final result = await AlumnoService.getHistorial();

    if (!mounted) return;

    if (result['success'] == true) {
      final List data = result['data'] ?? [];
      setState(() {
        _historial = data
            .map((e) => RegistroAsistencia.fromJson(e))
            .toList();
        _cargando = false;
      });
    } else {
      setState(() {
        _error = result['message'];
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: _cargando
          ? const LoadingState()
          : _error != null
          ? EmptyState(
        titulo: 'Error al cargar',
        descripcion: _error,
        icon: Icons.error_outline,
        actionLabel: 'Reintentar',
        onAction: _cargar,
      )
          : _historial.isEmpty
          ? const EmptyState(
        titulo: 'Sin historial',
        descripcion: 'Aún no tienes asistencias registradas.',
        icon: Icons.history,
      )
          : RefreshIndicator(
        onRefresh: _cargar,
        child: ListView.separated(
          padding: AppSpacing.paddingScreen,
          itemCount: _historial.length,
          separatorBuilder: (_, __) => AppSpacing.vGapXs,
          itemBuilder: (_, i) {
            final r = _historial[i];
            return InfoCard(
              child: Row(
                children: [
                  AttendanceStatusChip(
                    estado: r.estado,
                    compact: true,
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.materia,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall,
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
            );
          },
        ),
      ),
    );
  }
}