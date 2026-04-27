/// =============================================================================
/// lista_alumnos_view.dart
/// -----------------------------------------------------------------------------
/// RF-08: Lista de alumnos del grupo. El docente puede dar de baja
/// manualmente a un alumno y ver su historial de asistencia.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/session/session_service.dart';
import '../viewmodel/grupos_viewmodel.dart';

class ListaAlumnosView extends StatelessWidget {
  const ListaAlumnosView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GruposViewModel(context.read<SessionService>())..cargar(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Alumnos del grupo')),
        body: Consumer<GruposViewModel>(
          builder: (_, vm, __) {
            if (vm.cargando) return const LoadingState();
            if (vm.grupos.isEmpty) {
              return const EmptyState(
                titulo: 'Sin grupos cargados',
                icon: Icons.groups_outlined,
              );
            }
            final grupo = vm.grupos.first;
            return Column(
              children: [
                Padding(
                  padding: AppSpacing.paddingScreen,
                  child: SectionHeader(
                    titulo: '${grupo.materia} · ${grupo.nombre}',
                    subtitulo:
                        '${grupo.alumnos.length}/${grupo.capacidadMaxima} alumnos · '
                        '${grupo.periodoAcademico}',
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: AppSpacing.paddingScreenHorizontal,
                    itemCount: grupo.alumnos.length,
                    separatorBuilder: (_, __) => AppSpacing.vGapSm,
                    itemBuilder: (_, i) {
                      final a = grupo.alumnos[i];
                      return InfoCard(
                        onTap: () => Navigator.of(context).pushNamed(
                          RouteNames.detalleAlumnoAsistencia,
                          arguments: a,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.10),
                              child: Text(
                                a.nombre.substring(0, 1),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            AppSpacing.hGapMd,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.nombre,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall,
                                  ),
                                  Text(
                                    '${a.matricula} · ${(a.porcentaje * 100).toStringAsFixed(0)}% asist.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.textSecondary,
                            ),
                            AppSpacing.hGapSm,
                            IconButton(
                              icon: const Icon(
                                Icons.person_remove,
                                color: AppColors.error,
                              ),
                              tooltip: 'Dar de baja del grupo',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Baja simulada de ${a.nombre}'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                AppSpacing.vGapLg,
              ],
            );
          },
        ),
      ),
    );
  }
}
