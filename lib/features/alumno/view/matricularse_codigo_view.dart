/// @file: matricularse_codigo_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: RF-06: El alumno se une a un grupo con código real de Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';
import '../../../services/alumno_service.dart';

class MatricularseCodigoView extends StatefulWidget {
  const MatricularseCodigoView({super.key});

  @override
  State<MatricularseCodigoView> createState() => _MatricularseCodigoViewState();
}

class _MatricularseCodigoViewState extends State<MatricularseCodigoView> {
  final TextEditingController _codigo = TextEditingController();
  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _codigo.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_codigo.text.trim().isEmpty) {
      setState(() => _error = 'Ingresa el código del grupo.');
      return;
    }

    setState(() {
      _enviando = true;
      _error = null;
    });

    final result = await AlumnoService.matricularse(
      invitationCode: _codigo.text.trim(),
    );

    if (!mounted) return;

    setState(() => _enviando = false);

    if (result['success'] == true) {
      final materia = result['data']['data']['materia'] ?? 'el grupo';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Te uniste a $materia correctamente!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacementNamed(RouteNames.dashboardAlumno);
    } else {
      setState(() => _error = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unirme con código')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                titulo: 'Código del grupo',
                subtitulo:
                'Ingresa el código que te dio el docente.',
              ),
              AppSpacing.vGapMd,
              StandardTextField(
                controller: _codigo,
                label: 'Código del grupo',
                prefixIcon: Icons.vpn_key,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[A-Za-z0-9\-]'),
                  ),
                ],
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
                label: 'Unirme al grupo',
                icon: Icons.group_add,
                isLoading: _enviando,
                onPressed: _enviando ? null : _onSubmit,
              ),
              AppSpacing.vGapLg,
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushReplacementNamed(
                  RouteNames.escanearQr,
                ),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Mejor escanear un QR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}