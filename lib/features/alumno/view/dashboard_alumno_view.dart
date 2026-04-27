/// =============================================================================
/// dashboard_alumno_view.dart
/// -----------------------------------------------------------------------------
/// RF-03: Dashboard del alumno con la lista de materias vinculadas y atajos
/// para registrar asistencia, matricularse y ver notificaciones.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/section_header.dart';
import '../viewmodel/dashboard_alumno_viewmodel.dart';
import '../widgets/materia_card.dart';

class DashboardAlumnoView extends StatelessWidget {
  const DashboardAlumnoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardAlumnoViewModel()..cargar(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi tablero'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Notificaciones',
              onPressed: () => Navigator.of(context).pushNamed(
                RouteNames.notificaciones,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Cerrar sesión',
              onPressed: () {
                context.read<SessionService>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.login,
                  (_) => false,
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pushNamed(
            RouteNames.registroAsistencia,
          ),
          icon: const Icon(Icons.qr_code_2),
          label: const Text('Pasar lista'),
        ),
        body: Consumer<DashboardAlumnoViewModel>(
          builder: (_, vm, __) {
            if (vm.cargando) {
              return const LoadingState(mensaje: 'Cargando tus materias…');
            }
            if (vm.materias.isEmpty) {
              return EmptyState(
                titulo: 'Aún no tienes materias',
                descripcion:
                    'Únete a un grupo con un código o un QR del docente.',
                icon: Icons.school_outlined,
                actionLabel: 'Matricularme',
                onAction: () => Navigator.of(context).pushNamed(
                  RouteNames.matricularseCodigo,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: vm.cargar,
              child: ListView(
                padding: AppSpacing.paddingScreen,
                children: [
                  _ResumenGlobal(porcentaje: vm.porcentajeGlobal),
                  AppSpacing.vGapLg,
                  _AccionesRapidas(),
                  AppSpacing.vGapLg,
                  const SectionHeader(titulo: 'Mis materias'),
                  AppSpacing.vGapSm,
                  ...vm.materias.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: MateriaCard(
                        materia: m,
                        onTap: () => Navigator.of(context).pushNamed(
                          RouteNames.detalleMateria,
                          arguments: {'materiaId': m.id},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ResumenGlobal extends StatelessWidget {
  const _ResumenGlobal({required this.porcentaje});
  final double porcentaje;

  @override
  Widget build(BuildContext context) {
    final pct = (porcentaje * 100).toStringAsFixed(0);
    final t = Theme.of(context).textTheme;
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$pct%',
                style: t.titleMedium?.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asistencia global',
                  style: t.titleMedium?.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
                AppSpacing.vGapXs,
                Text(
                  'Promedio considerando todas tus materias.',
                  style: t.bodySmall?.copyWith(
                    color:
                        AppColors.textOnPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccionesRapidas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(
              RouteNames.matricularseCodigo,
            ),
            icon: const Icon(Icons.vpn_key),
            label: const Text('Código'),
          ),
        ),
        AppSpacing.hGapMd,
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(
              RouteNames.escanearQr,
            ),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('QR'),
          ),
        ),
      ],
    );
  }
}
