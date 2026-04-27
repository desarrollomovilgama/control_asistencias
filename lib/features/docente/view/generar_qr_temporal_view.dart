/// =============================================================================
/// generar_qr_temporal_view.dart
/// -----------------------------------------------------------------------------
/// RF-07: Genera un QR temporal para matriculación individual extemporánea.
/// El render real usa qr_flutter; aquí dejamos la integración lista.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';

class GenerarQrTemporalView extends StatefulWidget {
  const GenerarQrTemporalView({super.key});

  @override
  State<GenerarQrTemporalView> createState() => _GenerarQrTemporalViewState();
}

class _GenerarQrTemporalViewState extends State<GenerarQrTemporalView> {
  String _payload = _payloadInicial();
  int _vigenciaMin = 10;

  static String _payloadInicial() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    return 'gama://matricula?grupo=ITT-PM-A26&exp=$ts';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR temporal')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                titulo: 'Matriculación individual',
                subtitulo:
                    'Útil cuando un alumno se incorpora tarde y no tiene el '
                    'código del grupo.',
              ),
              AppSpacing.vGapMd,
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: QrImageView(
                    data: _payload,
                    size: 240,
                    backgroundColor: AppColors.surface,
                  ),
                ),
              ),
              AppSpacing.vGapLg,
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vigencia: $_vigenciaMin minutos',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Slider(
                      value: _vigenciaMin.toDouble(),
                      min: 5,
                      max: 60,
                      divisions: 11,
                      label: '$_vigenciaMin min',
                      onChanged: (v) =>
                          setState(() => _vigenciaMin = v.round()),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              PrimaryButton(
                label: 'Regenerar QR',
                icon: Icons.autorenew,
                onPressed: () => setState(() {
                  _payload = _payloadInicial();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
