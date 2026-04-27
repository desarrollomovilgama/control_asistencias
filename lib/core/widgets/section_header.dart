/// =============================================================================
/// section_header.dart
/// -----------------------------------------------------------------------------
/// Encabezado de sección reutilizable. Apartado 4.2 del MPF.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.trailing,
  });

  final String titulo;
  final String? subtitulo;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: t.titleMedium),
                if (subtitulo != null) ...[
                  AppSpacing.vGapXs,
                  Text(subtitulo!, style: t.bodySmall),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
