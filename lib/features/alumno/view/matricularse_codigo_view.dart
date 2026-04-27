/// =============================================================================
/// matricularse_codigo_view.dart
/// -----------------------------------------------------------------------------
/// RF-06: El alumno se une a un grupo ingresando un código alfanumérico
/// (funcionamiento similar a Microsoft Teams).
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';

class MatricularseCodigoView extends StatefulWidget {
  const MatricularseCodigoView({super.key});

  @override
  State<MatricularseCodigoView> createState() => _MatricularseCodigoViewState();
}

class _MatricularseCodigoViewState extends State<MatricularseCodigoView> {
  final TextEditingController _codigo = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _codigo.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() => _enviando = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _enviando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Código aceptado (mock). La materia aparecerá en tu tablero.',
        ),
      ),
    );
    Navigator.of(context).pop();
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
                    'Ingresa el código que te dictó el docente. Si está '
                    'vencido, pide uno nuevo (RF-06).',
              ),
              AppSpacing.vGapMd,
              StandardTextField(
                controller: _codigo,
                label: 'Código (ej. ITT-2026-AB12)',
                prefixIcon: Icons.vpn_key,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]')),
                ],
              ),
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
