/// =============================================================================
/// generar_clave_view.dart
/// -----------------------------------------------------------------------------
/// RF-01: Genera la clave de asistencia y muestra el toggle para abrir/cerrar
/// la ventana de recepción.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../viewmodel/clave_asistencia_viewmodel.dart';

class GenerarClaveView extends StatelessWidget {
  const GenerarClaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClaveAsistenciaViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Clave de asistencia')),
        body: Consumer<ClaveAsistenciaViewModel>(
          builder: (_, vm, __) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!vm.dentroDeHorario)
                      _BannerHorario(onAlternar: vm.alternarHorario),
                    if (!vm.dentroDeHorario) AppSpacing.vGapMd,
                    const SectionHeader(
                      titulo: 'Sesión actual',
                      subtitulo:
                          'La clave sólo se genera dentro del horario del grupo.',
                    ),
                    AppSpacing.vGapMd,
                    _ClaveBox(clave: vm.clave),
                    AppSpacing.vGapLg,
                    SwitchListTile.adaptive(
                      title: Text(
                        vm.abierta
                            ? 'Ventana ABIERTA — los alumnos pueden enviar'
                            : 'Ventana CERRADA — no se aceptan claves',
                      ),
                      subtitle: const Text(
                        'Los alumnos sólo pueden enviar mientras esté abierta.',
                      ),
                      activeThumbColor: AppColors.success,
                      value: vm.abierta,
                      onChanged: (v) {
                        if (v) {
                          vm.abrir();
                        } else {
                          vm.cerrar();
                        }
                      },
                    ),
                    AppSpacing.vGapMd,
                    InfoCard(
                      child: Row(
                        children: [
                          const Icon(Icons.how_to_reg,
                              color: AppColors.primary),
                          AppSpacing.hGapMd,
                          Expanded(
                            child: Text(
                              'Alumnos registrados: ${vm.registrados}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Simular un registro',
                            onPressed: vm.abierta ? vm.simularRegistro : null,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vGapXl,
                    PrimaryButton(
                      label: vm.abierta ? 'Generar nueva clave' : 'Abrir sesión',
                      icon: Icons.refresh,
                      onPressed: vm.dentroDeHorario ? vm.abrir : null,
                    ),
                    AppSpacing.vGapMd,
                    OutlinedButton.icon(
                      onPressed: vm.alternarHorario,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        vm.dentroDeHorario
                            ? 'Simular fuera de horario'
                            : 'Volver a horario válido',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BannerHorario extends StatelessWidget {
  const _BannerHorario({required this.onAlternar});
  final VoidCallback onAlternar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: AppColors.warning),
          AppSpacing.hGapSm,
          const Expanded(
            child: Text(
              'No hay sesión activa en este horario. Sólo puedes generar '
              'claves dentro del rango configurado del grupo.',
            ),
          ),
        ],
      ),
    );
  }
}

class _ClaveBox extends StatelessWidget {
  const _ClaveBox({required this.clave});
  final String? clave;

  @override
  Widget build(BuildContext context) {
    final placeholder = clave == null;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            placeholder ? 'Genera una clave' : 'Clave activa',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color:
                      AppColors.textOnPrimary.withValues(alpha: 0.85),
                ),
          ),
          AppSpacing.vGapSm,
          Text(
            placeholder ? '— — — — — — — —' : clave!,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.textOnPrimary,
                  letterSpacing: 4,
                ),
          ),
          if (!placeholder) ...[
            AppSpacing.vGapSm,
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: clave!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Clave copiada')),
                );
              },
              icon: const Icon(Icons.copy, color: AppColors.textOnPrimary),
              label: const Text(
                'Copiar',
                style: TextStyle(color: AppColors.textOnPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
