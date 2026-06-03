/// @file: configurar_rubros_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Configuración de rubros — pendiente de integración con backend.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class ConfigurarRubrosView extends StatelessWidget {
  const ConfigurarRubrosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rubros y porcentajes')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.paddingScreen,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flag_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                AppSpacing.vGapMd,
                Text(
                  'Próximamente',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AppSpacing.vGapSm,
                Text(
                  'La configuración de rubros estará disponible en la siguiente versión.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}