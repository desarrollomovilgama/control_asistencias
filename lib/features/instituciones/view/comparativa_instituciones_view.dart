/// =============================================================================
/// comparativa_instituciones_view.dart
/// -----------------------------------------------------------------------------
/// Vista combinada que muestra Instituto Tecnológico y Universidad
/// LADO A LADO en pantallas anchas, o apilados en pantallas angostas.
/// Pensada para que el docente compare ambos espacios de un solo vistazo.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../model/institucion_model.dart';
import '../widgets/panel_institucion.dart';

class ComparativaInstitucionesView extends StatelessWidget {
  const ComparativaInstitucionesView({super.key});

  static const String _descTec =
      'En el TEC el alumno tiene un único rubro (Complementario) con 80% de '
      'asistencia mínima. La notificación de justificante llega en cuanto '
      'la coordinación lo emite.';

  static const String _descUni =
      'La Universidad maneja Ordinario / Extraordinario / Título con '
      'porcentajes distintos. El alumno tiene 7 días tras regresar para '
      'entregar el justificante.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparativa de espacios'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                titulo: 'Reglas y rubros por institución',
                subtitulo:
                    'Cada espacio opera con configuración independiente '
                    '(RF-04 / RF-05). Aquí los ves uno al lado del otro.',
              ),
              AppSpacing.vGapMd,
              LayoutBuilder(
                builder: (context, constraints) {
                  // En pantallas estrechas (móvil portrait), apila verticalmente.
                  // En pantallas anchas (tablet, web, desktop) usa Row.
                  final ancho = constraints.maxWidth;
                  if (ancho < 600) {
                    return Column(
                      children: [
                        PanelInstitucion(
                          institucion: InstitucionesDemo.tec,
                          descripcion: _descTec,
                        ),
                        AppSpacing.vGapMd,
                        PanelInstitucion(
                          institucion: InstitucionesDemo.universidad,
                          descripcion: _descUni,
                        ),
                      ],
                    );
                  }
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: PanelInstitucion(
                            institucion: InstitucionesDemo.tec,
                            descripcion: _descTec,
                          ),
                        ),
                        AppSpacing.hGapMd,
                        Expanded(
                          child: PanelInstitucion(
                            institucion: InstitucionesDemo.universidad,
                            descripcion: _descUni,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              AppSpacing.vGapLg,
              const _ChipDeAyuda(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipDeAyuda extends StatelessWidget {
  const _ChipDeAyuda();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info),
          AppSpacing.hGapMd,
          Expanded(
            child: Text(
              'Esta vista es informativa. Para entrar a un espacio, regresa '
              'al selector y toca la institución.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
