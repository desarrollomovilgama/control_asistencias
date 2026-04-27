/// =============================================================================
/// escanear_qr_view.dart
/// -----------------------------------------------------------------------------
/// RF-07: Lectura del QR temporal para matriculación extemporánea.
/// La integración con mobile_scanner queda comentada para evitar pedir
/// permisos antes de tiempo en la maqueta.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';

class EscanearQrView extends StatelessWidget {
  const EscanearQrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR del grupo')),
      body: Padding(
        padding: AppSpacing.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 96,
                        color: AppColors.textHint,
                      ),
                      AppSpacing.vGapMd,
                      Text(
                        'Vista previa de la cámara',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      AppSpacing.vGapXs,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Text(
                          'Cuando se conecte mobile_scanner aquí se abrirá la '
                          'cámara para leer el QR temporal del docente.',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.vGapLg,
            PrimaryButton(
              label: 'Simular lectura exitosa',
              icon: Icons.check_circle,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'QR procesado (mock). Quedaste matriculado en el grupo.',
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
