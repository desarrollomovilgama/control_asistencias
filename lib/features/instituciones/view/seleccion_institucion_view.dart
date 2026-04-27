/// =============================================================================
/// seleccion_institucion_view.dart
/// -----------------------------------------------------------------------------
/// RF-04: Panel de instituciones del docente (Comparar Instituciones).
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/section_header.dart';
import '../model/institucion_model.dart';
import '../viewmodel/instituciones_viewmodel.dart';
import '../widgets/institucion_tile.dart';

class SeleccionInstitucionView extends StatelessWidget {
  const SeleccionInstitucionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          InstitucionesViewModel(context.read<SessionService>())..cargar(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comparar Instituciones'),
          actions: [
            IconButton(
              tooltip: 'Cerrar sesión',
              icon: const Icon(Icons.logout),
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
        body: Consumer<InstitucionesViewModel>(
          builder: (_, vm, __) {
            if (vm.cargando) {
              return const LoadingState(mensaje: 'Cargando tus espacios…');
            }
            if (vm.instituciones.isEmpty) {
              return EmptyState(
                titulo: 'Aún no tienes instituciones',
                descripcion:
                    'Da de alta una institución para comenzar a registrar grupos.',
                icon: Icons.apartment_outlined,
                actionLabel: 'Agregar institución',
                onAction: () => Navigator.of(context).pushNamed(
                  RouteNames.altaInstitucion,
                ),
              );
            }
            return ListView(
              padding: AppSpacing.paddingScreen,
              children: [
                const SectionHeader(
                  titulo: 'Tus Instituciones',
                  subtitulo:
                      'Selecciona un espacio para gestionar tus clases y asistencias.',
                ),
                AppSpacing.vGapMd,
                ...vm.instituciones.map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: InstitucionTile(
                      institucion: i,
                      onTap: () => _onSeleccionar(context, vm, i),
                    ),
                  ),
                ),
                AppSpacing.vGapMd,
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed(
                    RouteNames.altaInstitucion,
                  ),
                  icon: const Icon(Icons.add_business),
                  label: const Text('Agregar nueva institución'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onSeleccionar(
    BuildContext context,
    InstitucionesViewModel vm,
    Institucion i,
  ) {
    vm.seleccionar(i);
    Navigator.of(context).pushNamed(RouteNames.homeDocente);
  }
}
