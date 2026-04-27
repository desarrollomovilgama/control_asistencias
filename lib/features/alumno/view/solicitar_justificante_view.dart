/// =============================================================================
/// solicitar_justificante_view.dart
/// -----------------------------------------------------------------------------
/// RF-09 (lado alumno): el alumno notifica al docente que tiene un
/// justificante emitido por la institución. El estatus oficial lo cambia
/// el docente; aquí solo se envía la solicitud.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';

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

  @override
  void dispose() {
    _razon.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    setState(() => _enviando = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _enviando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Solicitud enviada (mock). Estatus inicial: Pendiente.',
        ),
      ),
    );
    Navigator.of(context).pop();
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
                subtitulo: 'ID interno: ${widget.faltaId}',
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
                        'Aquí sólo notificas al docente para que lo revise.',
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              StandardTextField(
                controller: _razon,
                label: 'Razón de la ausencia',
                hint: 'Ej. Cita médica IMSS, comisión académica…',
                textCapitalization: TextCapitalization.sentences,
                maxLength: 200,
                keyboardType: TextInputType.multiline,
              ),
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
