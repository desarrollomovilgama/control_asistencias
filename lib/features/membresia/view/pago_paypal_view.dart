/// =============================================================================
/// pago_paypal_view.dart
/// -----------------------------------------------------------------------------
/// Placeholder de la pasarela PayPal Sandbox (RF-15 / entrevista 00:20).
/// La integración real se conectará después con el SDK / WebView de PayPal.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';

class PagoPaypalView extends StatefulWidget {
  const PagoPaypalView({super.key});

  @override
  State<PagoPaypalView> createState() => _PagoPaypalViewState();
}

class _PagoPaypalViewState extends State<PagoPaypalView> {
  bool _procesando = false;

  Future<void> _pagar() async {
    setState(() => _procesando = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _procesando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pago aprobado en Sandbox. Membresía activa.'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago con PayPal')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: AppSpacing.paddingCard,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock,
                        color: AppColors.textOnPrimary),
                    AppSpacing.hGapMd,
                    Expanded(
                      child: Text(
                        'Conexión segura · Sandbox PayPal',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: AppColors.textOnPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              const InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de la orden',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text('Plan: Mensual'),
                    Text('Total: \$199.00 MXN'),
                    Text('Vigencia: 30 días'),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Pagar con PayPal',
                icon: Icons.account_balance_wallet,
                isLoading: _procesando,
                onPressed: _procesando ? null : _pagar,
              ),
              AppSpacing.vGapMd,
              TextButton(
                onPressed: _procesando
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
