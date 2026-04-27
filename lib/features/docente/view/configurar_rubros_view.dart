/// =============================================================================
/// configurar_rubros_view.dart
/// -----------------------------------------------------------------------------
/// RF-05: Configuración de porcentajes de evaluación por rubro.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';
import '../../instituciones/model/institucion_model.dart';
import '../viewmodel/rubros_viewmodel.dart';

class ConfigurarRubrosView extends StatelessWidget {
  const ConfigurarRubrosView({super.key});

  @override
  Widget build(BuildContext context) {
    final inst = context.read<SessionService>().institucionActiva ??
        InstitucionesDemo.universidad;
    return ChangeNotifierProvider(
      create: (_) => RubrosViewModel(inst),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rubros y porcentajes'),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Agregar rubro',
                onPressed: () => _mostrarDialogoAgregar(context),
              ),
            ),
          ],
        ),
        body: Consumer<RubrosViewModel>(
          builder: (_, vm, __) {
            return SafeArea(
              child: ListView(
                padding: AppSpacing.paddingScreen,
                children: [
                  SectionHeader(
                    titulo: 'Institución: ${inst.nombre}',
                    subtitulo:
                        'Cada rubro define el % mínimo de asistencia para '
                        'tener derecho a esa evaluación (RF-05).',
                  ),
                  AppSpacing.vGapMd,
                  if (vm.rubros.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text('No hay rubros configurados.'),
                      ),
                    ),
                  ...List.generate(vm.rubros.length, (i) {
                    final r = vm.rubros[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: InfoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    r.nombre,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () => vm.eliminar(i),
                                ),
                              ],
                            ),
                            Slider(
                              value: r.porcentajeMinimo,
                              min: 0,
                              max: 1,
                              divisions: 20,
                              label:
                                  '${(r.porcentajeMinimo * 100).toStringAsFixed(0)}%',
                              onChanged: (v) => vm.actualizar(i, v),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  AppSpacing.vGapLg,
                  PrimaryButton(
                    label: 'Guardar configuración',
                    icon: Icons.save_outlined,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuración guardada (mock).'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _mostrarDialogoAgregar(BuildContext context) {
    final vm = context.read<RubrosViewModel>();
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Rubro'),
        content: StandardTextField(
          controller: controller,
          label: 'Nombre del rubro',
          hint: 'Ej. Examen Parcial',
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                vm.agregar(RubroEvaluacion(
                  nombre: controller.text,
                  porcentajeMinimo: 0.8,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
