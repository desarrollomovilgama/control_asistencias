/// @file: crear_grupo_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Alta de un nuevo grupo.
/// @version: 2.1.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';
import '../viewmodel/grupos_viewmodel.dart';

class CrearGrupoView extends StatelessWidget {
  const CrearGrupoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GruposViewModel(),
      child: const _CrearGrupoBody(),
    );
  }
}

class _CrearGrupoBody extends StatefulWidget {
  const _CrearGrupoBody();

  @override
  State<_CrearGrupoBody> createState() => _CrearGrupoBodyState();
}

class _CrearGrupoBodyState extends State<_CrearGrupoBody> {
  final _materia = TextEditingController();
  final _periodo = TextEditingController();
  final _umbral  = TextEditingController(text: '80');
  String? _error;

  @override
  void dispose() {
    _materia.dispose();
    _periodo.dispose();
    _umbral.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_materia.text.trim().isEmpty) {
      setState(() => _error = 'El nombre de la asignatura es obligatorio.');
      return;
    }
    final umbral = int.tryParse(_umbral.text) ?? 80;
    if (umbral < 0 || umbral > 100) {
      setState(() => _error = 'El umbral debe ser entre 0 y 100.');
      return;
    }

    setState(() => _error = null);

    final vm = context.read<GruposViewModel>();
    final ok = await vm.crearGrupo(
      subjectName:      _materia.text.trim(),
      period:           _periodo.text.trim(),
      minAttendancePct: umbral,
    );

    if (!mounted) return;

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
    return Scaffold(
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
              Consumer<GruposViewModel>(
                builder: (_, vm, __) => PrimaryButton(
                  label: 'Guardar grupo',
                  icon: Icons.save_outlined,
                  isLoading: vm.cargando,
                  onPressed: vm.cargando ? null : _guardar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}