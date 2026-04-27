/// =============================================================================
/// validar_justificantes_view.dart
/// -----------------------------------------------------------------------------
/// RF-09: Bandeja del docente con solicitudes de justificante.
/// Estados: Pendiente → Aceptado / Rechazado.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/section_header.dart';

enum EstadoJustificante { pendiente, aceptado, rechazado }

class _SolicitudJustificante {
  _SolicitudJustificante({
    required this.alumno,
    required this.materia,
    required this.fechaFalta,
    required this.razon,
    this.estado = EstadoJustificante.pendiente,
  });

  final String alumno;
  final String materia;
  final DateTime fechaFalta;
  final String razon;
  EstadoJustificante estado;
}

class ValidarJustificantesView extends StatefulWidget {
  const ValidarJustificantesView({super.key});

  @override
  State<ValidarJustificantesView> createState() =>
      _ValidarJustificantesViewState();
}

class _ValidarJustificantesViewState extends State<ValidarJustificantesView> {
  final List<_SolicitudJustificante> _solicitudes = [
    _SolicitudJustificante(
      alumno: 'Ana Pérez',
      materia: 'Programación móvil',
      fechaFalta: DateTime.now().subtract(const Duration(days: 2)),
      razon: 'Cita médica IMSS',
    ),
    _SolicitudJustificante(
      alumno: 'Luis Gómez',
      materia: 'Programación móvil',
      fechaFalta: DateTime.now().subtract(const Duration(days: 5)),
      razon: 'Comisión académica',
    ),
  ];

  void _resolver(int i, EstadoJustificante nuevo) {
    setState(() => _solicitudes[i].estado = nuevo);
  }

  Color _color(EstadoJustificante e) {
    switch (e) {
      case EstadoJustificante.pendiente:
        return AppColors.warning;
      case EstadoJustificante.aceptado:
        return AppColors.success;
      case EstadoJustificante.rechazado:
        return AppColors.error;
    }
  }

  String _label(EstadoJustificante e) {
    switch (e) {
      case EstadoJustificante.pendiente:
        return 'Pendiente';
      case EstadoJustificante.aceptado:
        return 'Aceptado';
      case EstadoJustificante.rechazado:
        return 'Rechazado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Justificantes')),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingScreen,
          children: [
            const SectionHeader(
              titulo: 'Solicitudes recibidas',
              subtitulo:
                  'El justificante OFICIAL lo emite la institución. Aquí '
                  'sólo cambias el estatus en la app del alumno.',
            ),
            AppSpacing.vGapSm,
            ...List.generate(_solicitudes.length, (i) {
              final s = _solicitudes[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.alumno,
                              style:
                                  Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: _color(s.estado).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _label(s.estado),
                              style: TextStyle(
                                color: _color(s.estado),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGapXs,
                      Text(
                        '${s.materia} · ${s.fechaFalta.day}/${s.fechaFalta.month}/${s.fechaFalta.year}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      AppSpacing.vGapSm,
                      Text(
                        '"${s.razon}"',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (s.estado == EstadoJustificante.pendiente) ...[
                        AppSpacing.vGapMd,
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _resolver(i, EstadoJustificante.rechazado),
                                icon: const Icon(Icons.close),
                                label: const Text('Rechazar'),
                              ),
                            ),
                            AppSpacing.hGapMd,
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _resolver(i, EstadoJustificante.aceptado),
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
