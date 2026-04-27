/// =============================================================================
/// plan_card.dart
/// -----------------------------------------------------------------------------
/// Tarjeta de plan con sus beneficios principales.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../model/plan_model.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.activo,
    required this.onSeleccionar,
  });

  final PlanMembresia plan;
  final bool activo;
  final VoidCallback onSeleccionar;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final accentColor = activo ? AppColors.success : AppColors.primary;
    return InfoCard(
      onTap: onSeleccionar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(plan.nombre, style: t.titleLarge)),
              if (activo)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Activo',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          AppSpacing.vGapSm,
          Text(
            plan.precioMensual == 0
                ? 'Gratis'
                : '\$${plan.precioMensual.toStringAsFixed(0)} MXN / mes',
            style: t.headlineSmall?.copyWith(color: accentColor),
          ),
          AppSpacing.vGapMd,
          _Beneficio(
            ok: true,
            texto: 'Hasta ${plan.maxAlumnosPorSalon} alumnos por salón',
          ),
          _Beneficio(ok: plan.aulasIlimitadas, texto: 'Aulas ilimitadas'),
          _Beneficio(
            ok: plan.reportesExcelPdf,
            texto: 'Reportes Excel y PDF',
          ),
          _Beneficio(
            ok: plan.gestionJustificantes,
            texto: 'Gestión de justificantes',
          ),
          _Beneficio(
            ok: true,
            texto: plan.historialDias == 0
                ? 'Historial sin límite'
                : 'Historial visible: ${plan.historialDias} días',
          ),
        ],
      ),
    );
  }
}

class _Beneficio extends StatelessWidget {
  const _Beneficio({required this.ok, required this.texto});
  final bool ok;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.remove_circle_outline,
            color: ok ? AppColors.success : AppColors.textHint,
            size: 18,
          ),
          AppSpacing.hGapSm,
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ok ? AppColors.textPrimary : AppColors.textHint,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
