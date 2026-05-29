/// @file: crear_grupo_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Alta de un nuevo grupo. Datos reales desde Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';
import '../viewmodel/grupos_viewmodel.dart';

class CrearGrupoView extends StatefulWidget {
  const CrearGrupoView({super.key});

  @override
  State<CrearGrupoView> createState() => _CrearGrupoViewState();
}

class _CrearGrupoViewState extends State<CrearGrupoView> {
  final TextEditingController _materia   = TextEditingController();
  final TextEditingController _periodo   = TextEditingController();
  final TextEditingController _capacidad = TextEditingController(text: '30');
  final TextEditingController _umbral    = TextEditingController(text: '80');
  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _materia.dispose();
    _periodo.dispose();
    _capacidad.dispose();
    _umbral.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_materia.text.trim().isEmpty) {
      setState(() => _error = 'El nombre de la asignatura es obligatorio.');
      return;
    }

    setState(() {
      _enviando = true;
      _error = null;
    });

    final vm = context.read<GruposViewModel>();

    final ok = await vm.crearGrupo(
      subjectName:      _materia.text.trim(),
      period:           _periodo.text.trim(),
      maxCapacity:      int.tryParse(_capacidad.text) ?? 30,
      minAttendancePct: int.tryParse(_umbral.text) ?? 80,
    );

    if (!mounted) return;
    setState(() => _enviando = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grupo creado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() => _error = vm.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GruposViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Crear grupo')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingScreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader(titulo: 'Datos del grupo'),
                AppSpacing.vGapMd,
                StandardTextField(
                  controller: _materia,
                  label: 'Asignatura',
                  prefixIcon: Icons.menu_book,
                  textCapitalization: TextCapitalization.words,
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
                AppSpacing.vGapMd,
                StandardTextField(
                  controller: _umbral,
                  label: 'Umbral mínimo de asistencia (%)',
                  hint: 'Ej. 80',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.percent,
                ),
                if (_error != null) ...[
                  AppSpacing.vGapSm,
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                AppSpacing.vGapXl,
                PrimaryButton(
                  label: 'Guardar grupo',
                  icon: Icons.save_outlined,
                  isLoading: _enviando,
                  onPressed: _enviando ? null : _guardar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}