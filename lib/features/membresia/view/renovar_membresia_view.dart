/// =============================================================================
/// renovar_membresia_view.dart
/// -----------------------------------------------------------------------------
/// RF-15: Pantalla mostrada cuando el periodo de gracia (72 h) expiró.
/// Bloquea las funciones del docente y solicita renovar.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';

class RenovarMembresiaView extends StatelessWidget {
  const RenovarMembresiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Renovar membresía')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingScreen,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.huge),
              const Icon(
                Icons.lock_clock,
                size: 96,
                color: AppColors.warning,
              ),
              AppSpacing.vGapLg,
              Text(
                'Tu membresía expiró',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              AppSpacing.vGapSm,
              Text(
                'Tu periodo de gracia de 72 horas terminó. Renueva tu plan '
                'para volver a usar las funciones del docente.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              AppSpacing.vGapXxl,
              const InfoCard(
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Tus credenciales siguen siendo válidas; sólo se '
                        'restringen las funciones del plan pagado.',
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              PrimaryButton(
                label: 'Renovar con PayPal',
                icon: Icons.credit_card,
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteNames.pagoPaypal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
