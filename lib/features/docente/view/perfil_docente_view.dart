/// =============================================================================
/// perfil_docente_view.dart
/// -----------------------------------------------------------------------------
/// Vista de perfil del docente donde se muestra su información y membresía.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';

class PerfilDocenteView extends StatelessWidget {
  const PerfilDocenteView({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionService>();
    final user = session.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: ListView(
        padding: AppSpacing.paddingScreen,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
          ),
          AppSpacing.vGapLg,
          Center(
            child: Text(
              user?.nombreCompleto ?? 'Docente',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Center(
            child: Text(
              user?.correo ?? 'correo@docente.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          AppSpacing.vGapXl,
          Text(
            'Membresía',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AppSpacing.vGapSm,
          InfoCard(
            onTap: () => Navigator.of(context).pushNamed(RouteNames.planes),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium,
                    color: AppColors.primary, size: 32),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan Mensual Activo',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Gestión hasta 50 alumnos por salón, reportes Excel/PDF y justificantes.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
          AppSpacing.vGapLg,
          const Divider(),
          AppSpacing.vGapLg,
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
            onTap: () {
              context.read<SessionService>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNames.login,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
