/// =============================================================================
/// attendance_status_chip.dart
/// -----------------------------------------------------------------------------
/// Chip que representa el estado de una clase del alumno (RF-03).
/// Verde = asistencia, rojo = falta, amarillo = justificada.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum EstadoAsistencia { asistencia, falta, justificada, sinRegistro }

class AttendanceStatusChip extends StatelessWidget {
  const AttendanceStatusChip({
    super.key,
    required this.estado,
    this.compact = false,
  });

  final EstadoAsistencia estado;
  final bool compact;

  Color get _color {
    switch (estado) {
      case EstadoAsistencia.asistencia:
        return AppColors.asistencia;
      case EstadoAsistencia.falta:
        return AppColors.falta;
      case EstadoAsistencia.justificada:
        return AppColors.justificada;
      case EstadoAsistencia.sinRegistro:
        return AppColors.sinRegistro;
    }
  }

  String get _label {
    switch (estado) {
      case EstadoAsistencia.asistencia:
        return 'Asistencia';
      case EstadoAsistencia.falta:
        return 'Falta';
      case EstadoAsistencia.justificada:
        return 'Justificada';
      case EstadoAsistencia.sinRegistro:
        return 'Sin registro';
    }
  }

  IconData get _icon {
    switch (estado) {
      case EstadoAsistencia.asistencia:
        return Icons.check_circle;
      case EstadoAsistencia.falta:
        return Icons.cancel;
      case EstadoAsistencia.justificada:
        return Icons.event_available;
      case EstadoAsistencia.sinRegistro:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
      );
    }
    return Chip(
      avatar: Icon(_icon, color: _color, size: 16),
      label: Text(_label),
      backgroundColor: _color.withValues(alpha: 0.12),
      labelStyle: TextStyle(color: _color, fontWeight: FontWeight.w600),
      side: BorderSide(color: _color.withValues(alpha: 0.4)),
    );
  }
}
