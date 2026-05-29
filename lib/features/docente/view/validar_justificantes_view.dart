/// @file: validar_justificantes_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: RF-09: Bandeja del docente con justificantes reales desde Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../../services/docente_service.dart';

class ValidarJustificantesView extends StatefulWidget {
  const ValidarJustificantesView({super.key});

  @override
  State<ValidarJustificantesView> createState() =>
      _ValidarJustificantesViewState();
}

class _ValidarJustificantesViewState extends State<ValidarJustificantesView> {
  List<Map<String, dynamic>> _justificantes = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final result = await DocenteService.getJustificantes();

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _justificantes = List<Map<String, dynamic>>.from(
          result['data'] ?? [],
        );
        _cargando = false;
      });
    } else {
      setState(() {
        _error = result['message'];
        _cargando = false;
      });
    }
  }

  Future<void> _resolver(String id, String status) async {
    final result = await DocenteService.resolverJustificante(
      justificationId: id,
      status: status,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'approved'
                ? 'Justificante aprobado.'
                : 'Justificante rechazado.',
          ),
          backgroundColor:
          status == 'approved' ? AppColors.success : AppColors.error,
        ),
      );
      await _cargar();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Error al resolver.')),
      );
    }
  }

  Color _color(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  String _label(String status) {
    switch (status) {
      case 'approved':
        return 'Aprobado';
      case 'rejected':
        return 'Rechazado';
      default:
        return 'Pendiente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Justificantes')),
      body: _cargando
          ? const LoadingState()
          : _error != null
          ? EmptyState(
        titulo: 'Error al cargar',
        descripcion: _error,
        icon: Icons.error_outline,
        actionLabel: 'Reintentar',
        onAction: _cargar,
      )
          : _justificantes.isEmpty
          ? const EmptyState(
        titulo: 'Sin justificantes',
        descripcion: 'No hay solicitudes pendientes.',
        icon: Icons.task_alt,
      )
          : RefreshIndicator(
        onRefresh: _cargar,
        child: ListView(
          padding: AppSpacing.paddingScreen,
          children: [
            const SectionHeader(
              titulo: 'Solicitudes recibidas',
              subtitulo:
              'El justificante OFICIAL lo emite la institución.',
            ),
            AppSpacing.vGapSm,
            ..._justificantes.map((j) {
              final fecha = DateTime.tryParse(
                j['fecha_falta'] ?? '',
              ) ??
                  DateTime.now();
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.md,
                ),
                child: InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              j['alumno'] ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: _color(j['status'])
                                  .withValues(alpha: 0.12),
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              _label(j['status']),
                              style: TextStyle(
                                color: _color(j['status']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGapXs,
                      Text(
                        '${j['materia']} · ${fecha.day}/${fecha.month}/${fecha.year}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                      AppSpacing.vGapSm,
                      Text(
                        '"${j['razon']}"',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                      if (j['status'] == 'pending') ...[
                        AppSpacing.vGapMd,
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _resolver(
                                  j['id'],
                                  'rejected',
                                ),
                                icon: const Icon(Icons.close),
                                label: const Text('Rechazar'),
                              ),
                            ),
                            AppSpacing.hGapMd,
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _resolver(
                                  j['id'],
                                  'approved',
                                ),
                                icon: const Icon(Icons.check),
                                label: const Text('Aceptar'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}