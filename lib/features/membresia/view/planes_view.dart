/// =============================================================================
/// planes_view.dart
/// -----------------------------------------------------------------------------
/// Comparativa de planes Básico vs Mensual (RF-15).
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/section_header.dart';
import '../model/plan_model.dart';
import '../viewmodel/membresia_viewmodel.dart';
import '../widgets/plan_card.dart';

class PlanesView extends StatelessWidget {
  const PlanesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MembresiaViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Planes y membresía')),
        body: Consumer<MembresiaViewModel>(
          builder: (_, vm, __) {
            return ListView(
              padding: AppSpacing.paddingScreen,
              children: [
                const SectionHeader(
                  titulo: 'Tu plan actual',
                  subtitulo:
                      'Consulta los beneficios de tu membresía activa.',
                ),
                AppSpacing.vGapMd,
                ...PlanesDemo.catalogo.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PlanCard(
                      plan: p,
                      activo: p.id == vm.plan.id,
                      // Se deshabilita la navegación a pago
                      onSeleccionar: () {},
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
