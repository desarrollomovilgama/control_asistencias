/// =============================================================================
/// panel_institucion.dart
/// -----------------------------------------------------------------------------
/// Panel compacto de una institución para usar en la vista comparativa
/// (lado a lado TEC vs Universidad). Reusa el modelo Institucion.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../model/institucion_model.dart';

class PanelInstitucion extends StatelessWidget {
  const PanelInstitucion({
    super.key,
    required this.institucion,
    required this.descripcion,
  });

  final Institucion institucion;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: institucion.colorPrimario.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(institucion: institucion),
          AppSpacing.vGapMd,
          Text(descripcion, style: t.bodySmall),
          AppSpacing.vGapMd,
          Text(
            'Rubros',
            style: t.labelLarge?.copyWith(color: institucion.colorPrimario),
          ),
          AppSpacing.vGapXs,
          ...institucion.rubros.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(Icons.flag, size: 14, color: institucion.colorPrimario),
                  AppSpacing.hGapSm,
                  Expanded(child: Text(r.nombre, style: t.bodyMedium)),
                  Text(
                    '${(r.porcentajeMinimo * 100).toStringAsFixed(0)}%',
                    style: t.labelMedium?.copyWith(
                      color: institucion.colorPrimario,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.vGapMd,
          _PoliticaJustificantes(inst: institucion),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.institucion});
  final Institucion institucion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: institucion.colorPrimario,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              institucion.nombre.substring(0, 1),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
        AppSpacing.hGapSm,
        Expanded(
          child: Text(
            institucion.nombre,
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PoliticaJustificantes extends StatelessWidget {
  const _PoliticaJustificantes({required this.inst});
  final Institucion inst;

  @override
  Widget build(BuildContext context) {
    final dias = inst.diasJustificantePosterior;
    final texto = dias == 0
        ? 'Justificante en cuanto llega la notificación.'
        : 'Hasta $dias día(s) tras regresar para entregar.';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: inst.colorPrimario.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.policy_outlined,
              size: 16, color: inst.colorPrimario),
          AppSpacing.hGapSm,
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
