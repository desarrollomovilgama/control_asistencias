/// =============================================================================
/// notificacion_tile.dart
/// -----------------------------------------------------------------------------
/// Tile estándar para una notificación. Cambia ícono y color según el tipo.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../model/notificacion_model.dart';

class NotificacionTile extends StatelessWidget {
  const NotificacionTile({super.key, required this.n});

  final Notificacion n;

  Color _color() {
    switch (n.tipo) {
      case TipoNotificacion.recordatorioClase:
        return AppColors.info;
      case TipoNotificacion.inasistencia:
        return AppColors.error;
      case TipoNotificacion.alertaPreventiva:
        return AppColors.warning;
      case TipoNotificacion.estadoJustificante:
        return AppColors.success;
      case TipoNotificacion.membresia:
        return AppColors.primary;
    }
  }

  IconData _icon() {
    switch (n.tipo) {
      case TipoNotificacion.recordatorioClase:
        return Icons.schedule;
      case TipoNotificacion.inasistencia:
        return Icons.event_busy;
      case TipoNotificacion.alertaPreventiva:
        return Icons.warning_amber;
      case TipoNotificacion.estadoJustificante:
        return Icons.assignment_turned_in;
      case TipoNotificacion.membresia:
        return Icons.workspace_premium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final t = Theme.of(context).textTheme;
    return InfoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(_icon(), color: color),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.titulo,
                  style: t.titleSmall?.copyWith(
                    fontWeight: n.leida ? FontWeight.w500 : FontWeight.w700,
                  ),
                ),
                AppSpacing.vGapXs,
                Text(n.mensaje, style: t.bodySmall),
              ],
            ),
          ),
          AppSpacing.hGapSm,
          if (!n.leida)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
