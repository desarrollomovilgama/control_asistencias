/// =============================================================================
/// demo_universidad_view.dart
/// -----------------------------------------------------------------------------
/// Vista demostrativa de la Universidad (RF-04).
/// Aplica el tema universitario y muestra los tres rubros configurados:
/// Ordinario (80%), Extraordinario (60%) y Título (20%).
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../model/institucion_model.dart';
import '../widgets/demo_institucion_layout.dart';

class DemoUniversidadView extends StatelessWidget {
  const DemoUniversidadView({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoInstitucionLayout(
      institucion: InstitucionesDemo.universidad,
      theme: AppTheme.universidad,
      descripcion:
          'En la Universidad coexisten tres rubros (Ordinario / Extraordinario '
          '/ Título). El alumno tiene 7 días después de regresar para entregar '
          'el justificante a su coordinación.',
    );
  }
}
