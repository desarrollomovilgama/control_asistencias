/// @file: alta_institucion_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Las instituciones se gestionan desde el portal web.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class AltaInstitucionView extends StatelessWidget {
  const AltaInstitucionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva institución')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.paddingScreen,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.apartment_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                AppSpacing.vGapMd,
                Text(
                  'Gestión de instituciones',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                AppSpacing.vGapSm,
                Text(
                  'Las instituciones se gestionan exclusivamente desde el portal web de GAMA. Contacta a tu administrador.',
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