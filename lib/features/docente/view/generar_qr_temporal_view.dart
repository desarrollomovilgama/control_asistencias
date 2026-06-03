/// @file: generar_qr_temporal_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Genera QR temporal de invitación para un grupo.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../services/docente_service.dart';

class GenerarQrTemporalView extends StatefulWidget {
  const GenerarQrTemporalView({super.key});

  @override
  State<GenerarQrTemporalView> createState() => _GenerarQrTemporalViewState();
}

class _GenerarQrTemporalViewState extends State<GenerarQrTemporalView> {
  String? _classroomId;
  String? _codigo;
  String? _expiresAt;
  int     _vigenciaDias = 1;
  bool    _cargando     = false;
  bool    _inicializado = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _classroomId = args['classroomId'] as String?;
      }
      _inicializado = true;
    }
  }

  Future<void> _generar() async {
    if (_classroomId == null) return;
    setState(() { _cargando = true; _error = null; });

    final result = await DocenteService.generarCodigoGrupo(
      classroomId: _classroomId!,
      dias:        _vigenciaDias,
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (result['success'] == true) {
      setState(() {
        _codigo    = result['data']['code'];
        _expiresAt = result['data']['expires_at'];
      });
    } else {
      setState(() => _error = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR temporal')),
      body: SafeArea(
        child: _classroomId == null
            ? const EmptyState(
          titulo: 'Sin grupo seleccionado',
          descripcion: 'Selecciona un grupo desde Mis Grupos.',
          icon: Icons.groups_outlined,
        )
            : SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                titulo: 'Matriculación individual',
                subtitulo:
                'El alumno escanea este QR para unirse al grupo.',
              ),
              AppSpacing.vGapMd,
              if (_cargando)
                const LoadingState(mensaje: 'Generando QR…')
              else if (_codigo != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: QrImageView(
                          data: _codigo!,
                          size: 240,
                          backgroundColor: AppColors.surface,
                        ),
                      ),
                      AppSpacing.vGapSm,
                      Text(
                        _codigo!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(letterSpacing: 3),
                        textAlign: TextAlign.center,
                      ),
                      if (_expiresAt != null)
                        Text(
                          'Expira: ${_expiresAt!.substring(0, 10)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textHint),
                        ),
                    ],
                  ),
                ),
              ] else
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.qr_code_2,
                      size: 80,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              if (_error != null) ...[
                AppSpacing.vGapSm,
                Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
                      max: 7,
                      divisions: 6,
                      label: '$_vigenciaDias',
                      onChanged: (v) =>
                          setState(() => _vigenciaDias = v.round()),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              PrimaryButton(
                label: _codigo != null ? 'Regenerar QR' : 'Generar QR',
                icon: Icons.qr_code_2,
                isLoading: _cargando,
                onPressed: _cargando ? null : _generar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}