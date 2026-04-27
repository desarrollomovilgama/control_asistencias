/// =============================================================================
/// historial_asistencias_view.dart
/// -----------------------------------------------------------------------------
/// Vista global del historial de asistencias del alumno (todas las materias).
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/attendance_status_chip.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../viewmodel/dashboard_alumno_viewmodel.dart';

class HistorialAsistenciasView extends StatelessWidget {
  const HistorialAsistenciasView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardAlumnoViewModel()..cargar(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Historial')),
        body: Consumer<DashboardAlumnoViewModel>(
          builder: (_, vm, __) {
            if (vm.cargando) return const LoadingState();
            if (vm.materias.isEmpty) {
              return const EmptyState(
                titulo: 'Sin historial',
                icon: Icons.history,
              );
            }
            return ListView(
              padding: AppSpacing.paddingScreen,
              children: vm.materias.expand((m) {
                return [
                  Text(
                    m.nombre,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  AppSpacing.vGapSm,
                  ...m.historial.map(
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
                              child: Text(
                                '${r.fecha.day}/${r.fecha.month}/${r.fecha.year}',
                              ),
                            ),
                            AttendanceStatusChip(estado: r.estado),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.vGapLg,
                ];
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
