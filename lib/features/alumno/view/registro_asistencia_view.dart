/// =============================================================================
/// registro_asistencia_view.dart
/// -----------------------------------------------------------------------------
/// RF-02: Vista principal del alumno durante la clase.
/// Captura la clave alfanumérica dictada por el docente y la envía.
/// El campo se inhabilita en cuanto el docente cierra la sesión.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';
import '../viewmodel/asistencia_viewmodel.dart';

class RegistroAsistenciaView extends StatefulWidget {
  const RegistroAsistenciaView({super.key});

  @override
  State<RegistroAsistenciaView> createState() => _RegistroAsistenciaViewState();
}

class _RegistroAsistenciaViewState extends State<RegistroAsistenciaView> {
  final TextEditingController _clave = TextEditingController();

  @override
  void dispose() {
    _clave.dispose();
    super.dispose();
  }

  String _mensaje(EnvioEstado e) {
    switch (e) {
      case EnvioEstado.exito:
        return '¡Listo! Tu asistencia quedó registrada.';
      case EnvioEstado.duplicado:
        return 'Ya registraste tu asistencia en esta sesión.';
      case EnvioEstado.claveInvalida:
        return 'La clave no coincide. Verifícala con el docente.';
      case EnvioEstado.sinSesion:
        return 'El docente cerró la ventana de registro.';
      default:
        return '';
    }
  }

  Color _color(EnvioEstado e) {
    switch (e) {
      case EnvioEstado.exito:
        return AppColors.success;
      case EnvioEstado.duplicado:
      case EnvioEstado.sinSesion:
        return AppColors.warning;
      case EnvioEstado.claveInvalida:
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AsistenciaViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pasar lista')),
        body: Consumer<AsistenciaViewModel>(
          builder: (_, vm, __) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeader(
                      titulo: 'Clave de la sesión',
                      subtitulo:
                          'Escribe la clave dictada por tu docente. El campo '
                          'se desactiva en cuanto cierra la ventana.',
                    ),
                    AppSpacing.vGapMd,
                    StandardTextField(
                      controller: _clave,
                      label: 'Clave (ej. GAMA1234)',
                      hint: 'Sólo letras y números',
                      autofocus: true,
                      enabled: vm.sesionAbierta && !vm.yaRegistrado,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 12,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9]'),
                        ),
                      ],
                      prefixIcon: Icons.password,
                    ),
                    AppSpacing.vGapMd,
                    PrimaryButton(
                      label: vm.yaRegistrado ? 'Asistencia registrada' : 'Enviar',
                      icon: Icons.send,
                      isLoading: vm.enviando,
                      onPressed: !vm.sesionAbierta || vm.yaRegistrado
                          ? null
                          : () => vm.enviarClave(_clave.text),
                    ),
                    AppSpacing.vGapLg,
                    if (vm.estado != EnvioEstado.idle &&
                        vm.estado != EnvioEstado.enviando)
                      Container(
                        padding: AppSpacing.paddingCard,
                        decoration: BoxDecoration(
                          color: _color(vm.estado).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _color(vm.estado).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: _color(vm.estado)),
                            AppSpacing.hGapSm,
                            Expanded(
                              child: Text(
                                _mensaje(vm.estado),
                                style: TextStyle(color: _color(vm.estado)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    AppSpacing.vGapXxl,
                    if (vm.sesionAbierta)
                      TextButton.icon(
                        onPressed: vm.cerrarSesion,
                        icon: const Icon(Icons.lock_clock),
                        label: const Text(
                          'Simular cierre de sesión por el docente',
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
