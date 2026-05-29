/// @file: solicitar_justificante_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: RF-09: Alumno solicita justificante. Datos reales desde Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';
import '../../../services/alumno_service.dart';

class SolicitarJustificanteView extends StatefulWidget {
  const SolicitarJustificanteView({super.key, required this.faltaId});

  final String faltaId;

  @override
  State<SolicitarJustificanteView> createState() =>
      _SolicitarJustificanteViewState();
}

class _SolicitarJustificanteViewState
    extends State<SolicitarJustificanteView> {
  final TextEditingController _razon = TextEditingController();
  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _razon.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_razon.text.trim().isEmpty) {
      setState(() => _error = 'Describe el motivo de tu ausencia.');
      return;
    }

    setState(() {
      _enviando = true;
      _error = null;
    });

    final result = await AlumnoService.solicitarJustificante(
      attendanceId: widget.faltaId,
      reason: _razon.text.trim(),
    );

    if (!mounted) return;

    setState(() => _enviando = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Justificante enviado. El docente lo revisará pronto.',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() => _error = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar justificante')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                titulo: 'Falta a justificar',
                subtitulo: 'ID: ${widget.faltaId}',
              ),
              AppSpacing.vGapMd,
              const InfoCard(
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'El justificante OFICIAL lo emite la institución. '
                            'Aquí solo notificas al docente para que lo revise.',
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              StandardTextField(
                controller: _razon,
                label: 'Motivo de la ausencia',
                hint: 'Ej. Cita médica IMSS, comisión académica...',
                textCapitalization: TextCapitalization.sentences,
                maxLength: 500,
                keyboardType: TextInputType.multiline,
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
              AppSpacing.vGapLg,
              PrimaryButton(
                label: 'Enviar solicitud',
                icon: Icons.send,
                isLoading: _enviando,
                onPressed: _enviando ? null : _enviar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}