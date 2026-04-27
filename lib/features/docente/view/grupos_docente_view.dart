/// =============================================================================
/// grupos_docente_view.dart
/// -----------------------------------------------------------------------------
/// Lista de grupos del docente para la institución activa.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../viewmodel/grupos_viewmodel.dart';
import '../widgets/grupo_card.dart';

class GruposDocenteView extends StatelessWidget {
  const GruposDocenteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GruposViewModel(context.read<SessionService>())..cargar(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mis grupos')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.of(context).pushNamed(RouteNames.crearGrupo),
          icon: const Icon(Icons.add),
          label: const Text('Nuevo grupo'),
        ),
        body: Consumer<GruposViewModel>(
          builder: (_, vm, __) {
            if (vm.cargando) return const LoadingState();
            if (vm.grupos.isEmpty) {
              return EmptyState(
                titulo: 'Sin grupos',
                descripcion:
                    'Crea tu primer grupo para empezar a registrar asistencia.',
                icon: Icons.groups_outlined,
                actionLabel: 'Crear grupo',
                onAction: () =>
                    Navigator.of(context).pushNamed(RouteNames.crearGrupo),
              );
            }
            return ListView(
              padding: AppSpacing.paddingScreen,
              children: vm.grupos
                  .map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: GrupoCard(
                        grupo: g,
                        onTap: () => Navigator.of(context).pushNamed(
                          RouteNames.listaAlumnos,
                          arguments: {'grupoId': g.id},
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
