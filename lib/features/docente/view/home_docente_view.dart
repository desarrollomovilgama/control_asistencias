/// =============================================================================
/// home_docente_view.dart
/// -----------------------------------------------------------------------------
/// Home del docente dentro de un espacio (RF-04).
/// Acciones principales: pasar lista, ver grupos, configurar rubros, etc.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../../instituciones/model/institucion_model.dart';
import '../widgets/accion_docente_tile.dart';

class HomeDocenteView extends StatelessWidget {
  const HomeDocenteView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionService>();
    final inst = session.institucionActiva ?? InstitucionesDemo.tec;
    return Scaffold(
      appBar: AppBar(
        title: Text(inst.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Comparar Instituciones',
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.seleccionInstitucion,
              (_) => false,
            ),
          ),
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
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingScreen,
          children: [
            _Resumen(institucion: inst),
            AppSpacing.vGapLg,
            const SectionHeader(titulo: 'Acciones rápidas'),
            AppSpacing.vGapSm,
            _GridAcciones(),
          ],
        ),
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({required this.institucion});
  final Institucion institucion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: institucion.colorPrimario,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.school,
              size: 36, color: AppColors.textOnPrimary),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institucion.nombre,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                ),
                Text(
                  '${institucion.rubros.length} rubro(s) · '
                  '${institucion.diasJustificantePosterior == 0 ? 'Justificante inmediato' : '${institucion.diasJustificantePosterior} días para entregar'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textOnPrimary
                            .withValues(alpha: 0.85),
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

class _GridAcciones extends StatelessWidget {
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
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.generarClave),
        ),
        AccionDocenteTile(
          label: 'Mis grupos',
          icon: Icons.groups,
          color: AppColors.info,
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.gruposDocente),
        ),
        AccionDocenteTile(
          label: 'Crear grupo',
          icon: Icons.add_circle_outline,
          color: AppColors.success,
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.crearGrupo),
        ),
        AccionDocenteTile(
          label: 'Código grupo',
          icon: Icons.qr_code_2,
          color: AppColors.accent,
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.generarCodigoGrupo),
        ),
        AccionDocenteTile(
          label: 'QR temporal',
          icon: Icons.qr_code,
          color: AppColors.uniPrimary,
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.generarQrTemporal),
        ),
        AccionDocenteTile(
          label: 'Rubros',
          icon: Icons.flag_outlined,
          color: AppColors.warning,
          onTap: () =>
              Navigator.of(context).pushNamed(RouteNames.configurarRubros),
        ),
      ],
    );
  }
}
