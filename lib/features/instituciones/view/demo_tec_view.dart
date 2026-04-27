/// =============================================================================
/// demo_tec_view.dart
/// -----------------------------------------------------------------------------
/// Vista demostrativa del Instituto Tecnológico (RF-04).
/// Solo aplica el tema TEC y muestra los rubros (Complementario 80%).
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../model/institucion_model.dart';
import '../widgets/demo_institucion_layout.dart';

class DemoTecView extends StatelessWidget {
  const DemoTecView({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoInstitucionLayout(
      institucion: InstitucionesDemo.tec,
      theme: AppTheme.tec,
      descripcion:
          'En el TEC el alumno tiene un único rubro (Complementario) con '
          '80% de asistencia mínima. Los justificantes se registran en cuanto '
          'llega la notificación al docente.',
    );
  }
}
