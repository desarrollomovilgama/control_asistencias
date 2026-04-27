/// =============================================================================
/// demo_institucion_layout.dart
/// -----------------------------------------------------------------------------
/// Layout reutilizable para las pantallas demo TEC y Universidad (RF-04).
/// Aplica un Theme local con el color de la institución, muestra header con
/// logo y resumen de rubros configurados.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../model/institucion_model.dart';

class DemoInstitucionLayout extends StatelessWidget {
  const DemoInstitucionLayout({
    super.key,
    required this.institucion,
    required this.theme,
    required this.descripcion,
  });

  final Institucion institucion;
  final ThemeData theme;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Demo · ${institucion.nombre}'),
          backgroundColor: institucion.colorPrimario,
          foregroundColor: AppColors.textOnPrimary,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingScreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Hero(institucion: institucion),
                AppSpacing.vGapLg,
                Text(
                  descripcion,
                  style: theme.textTheme.bodyMedium,
                ),
                AppSpacing.vGapLg,
                Text('Rubros configurados', style: theme.textTheme.titleMedium),
                AppSpacing.vGapSm,
                ...institucion.rubros.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: InfoCard(
                      child: Row(
                        children: [
                          Icon(Icons.flag_outlined,
                              color: institucion.colorPrimario),
                          AppSpacing.hGapMd,
                          Expanded(
                            child: Text(
                              r.nombre,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          Text(
                            'Mín ${(r.porcentajeMinimo * 100).toStringAsFixed(0)}%',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: institucion.colorPrimario,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.vGapLg,
                _PoliticaJustificantes(institucion: institucion),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.institucion});

  final Institucion institucion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: institucion.colorPrimario,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                institucion.nombre.substring(0, 1),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: institucion.colorPrimario,
                ),
              ),
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institucion.nombre,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
                Text(
                  'Vista de ejemplo institucional',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.85),
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

class _PoliticaJustificantes extends StatelessWidget {
  const _PoliticaJustificantes({required this.institucion});

  final Institucion institucion;

  @override
  Widget build(BuildContext context) {
    final dias = institucion.diasJustificantePosterior;
    final texto = dias == 0
        ? 'Política: el justificante debe registrarse en cuanto llega la '
            'notificación (sin temporalidad).'
        : 'Política: el alumno tiene $dias días después de regresar para '
            'entregar el justificante.';
    return InfoCard(
      child: Row(
        children: [
          Icon(Icons.policy_outlined, color: institucion.colorPrimario),
          AppSpacing.hGapMd,
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
