/// =============================================================================
/// generar_codigo_grupo_view.dart
/// -----------------------------------------------------------------------------
/// RF-06: Genera el código alfanumérico para que los alumnos se unan al grupo
/// (similar a Microsoft Teams). El código tiene vigencia configurable.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';

class GenerarCodigoGrupoView extends StatefulWidget {
  const GenerarCodigoGrupoView({super.key});

  @override
  State<GenerarCodigoGrupoView> createState() => _GenerarCodigoGrupoViewState();
}

class _GenerarCodigoGrupoViewState extends State<GenerarCodigoGrupoView> {
  String _codigo = 'ITT-PM-A26';
  int _vigenciaDias = 2;
  bool _activo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Código del grupo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                titulo: 'Código de matriculación',
                subtitulo:
                    'Compártelo con tus alumnos. Caduca según la vigencia '
                    'configurada o cuando lo cierres manualmente (RF-06).',
              ),
              AppSpacing.vGapMd,
              _CodigoCard(
                codigo: _codigo,
                activo: _activo,
                onCopiar: () {
                  Clipboard.setData(ClipboardData(text: _codigo));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código copiado')),
                  );
                },
              ),
              AppSpacing.vGapLg,
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vigencia: $_vigenciaDias día(s)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Slider(
                      value: _vigenciaDias.toDouble(),
                      min: 1,
                      max: 14,
                      divisions: 13,
                      label: '$_vigenciaDias',
                      onChanged: (v) =>
                          setState(() => _vigenciaDias = v.round()),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() {
                        _codigo = _generarCodigo();
                        _activo = true;
                      }),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Regenerar'),
                    ),
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: PrimaryButton(
                      label: _activo ? 'Cerrar código' : 'Reabrir',
                      icon: _activo ? Icons.lock : Icons.lock_open,
                      onPressed: () => setState(() => _activo = !_activo),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _generarCodigo() {
    final ts = DateTime.now().millisecondsSinceEpoch.remainder(10000);
    return 'GR-${ts.toString().padLeft(4, '0')}';
  }
}

class _CodigoCard extends StatelessWidget {
  const _CodigoCard({
    required this.codigo,
    required this.activo,
    required this.onCopiar,
  });

  final String codigo;
  final bool activo;
  final VoidCallback onCopiar;

  @override
  Widget build(BuildContext context) {
    final color = activo ? AppColors.primary : AppColors.textHint;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            activo ? 'Código activo' : 'Código cerrado',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                ),
          ),
          AppSpacing.vGapSm,
          Text(
            codigo,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textOnPrimary,
                  letterSpacing: 3,
                ),
          ),
          AppSpacing.vGapSm,
          TextButton.icon(
            onPressed: activo ? onCopiar : null,
            icon: const Icon(Icons.copy, color: AppColors.textOnPrimary),
            label: const Text(
              'Copiar',
              style: TextStyle(color: AppColors.textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
