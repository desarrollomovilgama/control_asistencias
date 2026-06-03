/// @file: grupos_docente_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Lista de grupos del docente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../model/grupo_model.dart';
import '../viewmodel/grupos_viewmodel.dart';
import '../widgets/grupo_card.dart';

class GruposDocenteView extends StatelessWidget {
  const GruposDocenteView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GruposViewModel()..cargar(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mis grupos')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).pushNamed(RouteNames.crearGrupo);
            if (context.mounted) {
              context.read<GruposViewModel>().cargar();
            }
          },
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
                    onTap: () => _mostrarOpciones(context, g),
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

  void _mostrarOpciones(BuildContext context, Grupo grupo) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                grupo.nombre,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.people_outline, color: AppColors.primary),
              title: const Text('Ver alumnos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  RouteNames.listaAlumnos,
                  arguments: {'classroomId': grupo.id},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_2, color: AppColors.accent),
              title: const Text('Generar código de invitación'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  RouteNames.generarCodigoGrupo,
                  arguments: {'classroomId': grupo.id},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.password, color: AppColors.success),
              title: const Text('Generar clave de asistencia'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  RouteNames.generarClave,
                  arguments: {'classroomId': grupo.id},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code, color: AppColors.uniPrimary),
              title: const Text('Generar QR temporal'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  RouteNames.generarQrTemporal,
                  arguments: {'classroomId': grupo.id},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}