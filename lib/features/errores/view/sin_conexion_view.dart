/// =============================================================================
/// sin_conexion_view.dart
/// -----------------------------------------------------------------------------
/// RF-13: Pantalla mostrada cuando no hay conexión a internet.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';

class SinConexionView extends StatelessWidget {
  const SinConexionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sin conexión')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingScreen,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.huge),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off,
                  color: AppColors.warning,
                  size: 80,
                ),
              ),
              AppSpacing.vGapXl,
              Text(
                'Sin conexión a internet',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.vGapSm,
              Text(
                'Verifica tu Wi-Fi o datos móviles e inténtalo de nuevo.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Reintentar',
                icon: Icons.refresh,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
