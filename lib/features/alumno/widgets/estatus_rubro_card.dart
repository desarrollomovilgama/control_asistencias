/// =============================================================================
/// estatus_rubro_card.dart
/// -----------------------------------------------------------------------------
/// Muestra el derecho a evaluación por rubro (RF-03).
/// Verde = cumple; rojo = no cumple.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../instituciones/model/institucion_model.dart';

class EstatusRubroCard extends StatelessWidget {
  const EstatusRubroCard({
    super.key,
    required this.rubro,
    required this.porcentajeActual,
  });

  final RubroEvaluacion rubro;
  final double porcentajeActual;

  bool get _cumple => porcentajeActual >= rubro.porcentajeMinimo;

  @override
  Widget build(BuildContext context) {
    final color = _cumple ? AppColors.success : AppColors.error;
    return InfoCard(
      child: Row(
        children: [
          Icon(
            _cumple ? Icons.check_circle : Icons.cancel,
            color: color,
            size: 28,
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rubro.nombre,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AppSpacing.vGapXs,
                Text(
                  _cumple
                      ? 'Tienes derecho — vas con ${(porcentajeActual * 100).toStringAsFixed(0)}%'
                      : 'No alcanzas el ${(rubro.porcentajeMinimo * 100).toStringAsFixed(0)}% requerido',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
