/// @file: home_docente_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Home del docente con datos reales de sesión.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../widgets/accion_docente_tile.dart';

class HomeDocenteView extends StatelessWidget {
  const HomeDocenteView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionService>();
    final inst    = session.institucionActiva;
    final nombre  = inst?.nombre ?? session.usuario?.nombreCompleto ?? 'Docente';

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Mi Perfil',
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteNames.perfilDocente),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteNames.notificaciones),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await session.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNames.login,
                    (_) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingScreen,
          children: [
            _Resumen(nombre: nombre),
            AppSpacing.vGapLg,
            const SectionHeader(titulo: 'Acciones rápidas'),
            AppSpacing.vGapSm,
            const _GridAcciones(),
          ],
        ),
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({required this.nombre});
  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.school, size: 36, color: AppColors.textOnPrimary),
          AppSpacing.hGapMd,
          Expanded(
            child: Text(
              nombre,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridAcciones extends StatelessWidget {
  const _GridAcciones();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.95,
      children: [
        AccionDocenteTile(
          label: 'Generar clave',
          icon: Icons.password,
          color: AppColors.primary,
          onTap: () => Navigator.of(context).pushNamed(RouteNames.generarClave),
        ),
        AccionDocenteTile(
          label: 'Mis grupos',
          icon: Icons.groups,
          color: AppColors.info,
          onTap: () => Navigator.of(context).pushNamed(RouteNames.gruposDocente),
        ),
        AccionDocenteTile(
          label: 'Crear grupo',
          icon: Icons.add_circle_outline,
          color: AppColors.success,
          onTap: () => Navigator.of(context).pushNamed(RouteNames.crearGrupo),
        ),
        AccionDocenteTile(
          label: 'Justificantes',
          icon: Icons.task_alt,
          color: AppColors.warning,
          onTap: () => Navigator.of(context).pushNamed(RouteNames.validarJustificantes),
        ),
      ],
    );
  }
}