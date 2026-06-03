/// @file: reportes_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Reportes de asistencia - próximamente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class ReportesView extends StatelessWidget {
  const ReportesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.paddingScreen,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bar_chart,
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
                  'La generación de reportes Excel y PDF estará disponible en la siguiente versión.',
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