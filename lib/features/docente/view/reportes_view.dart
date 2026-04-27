/// =============================================================================
/// reportes_view.dart
/// -----------------------------------------------------------------------------
/// Reportes de asistencia (Excel / PDF) — sólo plan mensual.
/// La generación real se conectará a la capa de servicios después.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/section_header.dart';

class ReportesView extends StatelessWidget {
  const ReportesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.paddingScreen,
          children: [
            const SectionHeader(
              titulo: 'Generar reportes',
              subtitulo:
                  'Disponible sólo en el plan mensual. Se enviarán a tu '
                  'correo institucional.',
            ),
            AppSpacing.vGapMd,
            _ReporteTile(
              titulo: 'Lista de asistencia (Excel)',
              icon: Icons.table_chart,
              color: AppColors.success,
              descripcion: 'Por grupo, por periodo o por rango de fechas.',
            ),
            AppSpacing.vGapSm,
            _ReporteTile(
              titulo: 'Resumen por rubro (PDF)',
              icon: Icons.picture_as_pdf,
              color: AppColors.error,
              descripcion: 'Quién tiene derecho a Ordinario / Extra / Título.',
            ),
            AppSpacing.vGapSm,
            _ReporteTile(
              titulo: 'Cierre de periodo',
              icon: Icons.lock_clock,
              color: AppColors.warning,
              descripcion:
                  'Imprime resultados generales y elimina los grupos del '
                  'periodo (entrevista 00:22).',
            ),
          ],
        ),
      ),
    );
  }
}

class _ReporteTile extends StatelessWidget {
  const _ReporteTile({
    required this.titulo,
    required this.icon,
    required this.color,
    required this.descripcion,
  });

  final String titulo;
  final IconData icon;
  final Color color;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generando "$titulo" (mock)…')),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: Theme.of(context).textTheme.titleSmall),
                Text(descripcion,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textHint),
        ],
      ),
    );
  }
}
