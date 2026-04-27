/// =============================================================================
/// crear_grupo_view.dart
/// -----------------------------------------------------------------------------
/// Alta de un nuevo grupo. Datos: institución, materia, grupo, periodo,
/// días/horario, capacidad. (Configuración de rubros vive en su propia vista.)
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';

class CrearGrupoView extends StatefulWidget {
  const CrearGrupoView({super.key});

  @override
  State<CrearGrupoView> createState() => _CrearGrupoViewState();
}

class _CrearGrupoViewState extends State<CrearGrupoView> {
  final TextEditingController _materia = TextEditingController();
  final TextEditingController _grupo = TextEditingController();
  final TextEditingController _periodo = TextEditingController();
  final TextEditingController _capacidad = TextEditingController(text: '30');

  final Set<String> _dias = {'Lun', 'Mié'};
  final TextEditingController _horaInicio = TextEditingController(text: '07:00');
  final TextEditingController _horaFin = TextEditingController(text: '08:30');

  static const List<String> _diasSemana = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
  ];

  @override
  void dispose() {
    _materia.dispose();
    _grupo.dispose();
    _periodo.dispose();
    _capacidad.dispose();
    _horaInicio.dispose();
    _horaFin.dispose();
    super.dispose();
  }

  void _guardar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grupo creado (mock). Conexión real pendiente.'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear grupo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(titulo: 'Datos básicos'),
              AppSpacing.vGapMd,
              StandardTextField(
                controller: _materia,
                label: 'Asignatura',
                prefixIcon: Icons.menu_book,
                textCapitalization: TextCapitalization.words,
              ),
              AppSpacing.vGapMd,
              StandardTextField(
                controller: _grupo,
                label: 'Identificador del grupo',
                prefixIcon: Icons.tag,
                textCapitalization: TextCapitalization.characters,
              ),
              AppSpacing.vGapMd,
              StandardTextField(
                controller: _periodo,
                label: 'Periodo académico',
                hint: 'Ej. 2026-1',
                prefixIcon: Icons.calendar_today,
              ),
              AppSpacing.vGapMd,
              StandardTextField(
                controller: _capacidad,
                label: 'Capacidad máxima',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.group,
              ),
              AppSpacing.vGapLg,
              const SectionHeader(titulo: 'Horario'),
              AppSpacing.vGapSm,
              Wrap(
                spacing: AppSpacing.sm,
                children: _diasSemana.map((d) {
                  final sel = _dias.contains(d);
                  return FilterChip(
                    label: Text(d),
                    selected: sel,
                    onSelected: (v) => setState(() {
                      if (v) {
                        _dias.add(d);
                      } else {
                        _dias.remove(d);
                      }
                    }),
                  );
                }).toList(),
              ),
              AppSpacing.vGapMd,
              Row(
                children: [
                  Expanded(
                    child: StandardTextField(
                      controller: _horaInicio,
                      label: 'Hora inicio',
                      prefixIcon: Icons.access_time,
                    ),
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: StandardTextField(
                      controller: _horaFin,
                      label: 'Hora fin',
                      prefixIcon: Icons.access_time_filled,
                    ),
                  ),
                ],
              ),
              AppSpacing.vGapXl,
              PrimaryButton(
                label: 'Guardar grupo',
                icon: Icons.save_outlined,
                onPressed: _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
