/// @file: generar_codigo_grupo_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Genera código de invitación para un grupo.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../services/docente_service.dart';

class GenerarCodigoGrupoView extends StatefulWidget {
  const GenerarCodigoGrupoView({super.key});

  @override
  State<GenerarCodigoGrupoView> createState() =>
      _GenerarCodigoGrupoViewState();
}

class _GenerarCodigoGrupoViewState extends State<GenerarCodigoGrupoView> {
  // classroomId puede venir como argumento de navegación
  String? _classroomId;
  String? _codigo;
  String? _expiresAt;
  int     _vigenciaDias = 7;
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
      appBar: AppBar(title: const Text('Código del grupo')),
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
                titulo: 'Código de invitación',
                subtitulo:
                'Compártelo con tus alumnos para que se unan al grupo.',
              ),
              AppSpacing.vGapMd,
              if (_cargando)
                const LoadingState(mensaje: 'Generando código…')
              else if (_codigo != null)
                _CodigoCard(
                  codigo: _codigo!,
                  expiresAt: _expiresAt,
                  onCopiar: () {
                    Clipboard.setData(ClipboardData(text: _codigo!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado')),
                    );
                  },
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
                      max: 30,
                      divisions: 29,
                      label: '$_vigenciaDias',
                      onChanged: (v) =>
                          setState(() => _vigenciaDias = v.round()),
                    ),
                  ],
                ),
              ),
              AppSpacing.vGapLg,
              PrimaryButton(
                label: _codigo != null ? 'Regenerar código' : 'Generar código',
                icon: Icons.refresh,
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

class _CodigoCard extends StatelessWidget {
  const _CodigoCard({
    required this.codigo,
    required this.onCopiar,
    this.expiresAt,
  });

  final String  codigo;
  final String? expiresAt;
  final VoidCallback onCopiar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Código activo',
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
          if (expiresAt != null) ...[
            AppSpacing.vGapXs,
            Text(
              'Expira: ${expiresAt!.substring(0, 10)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.75),
              ),
            ),
          ],
          AppSpacing.vGapSm,
          TextButton.icon(
            onPressed: onCopiar,
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