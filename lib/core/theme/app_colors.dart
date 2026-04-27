/// =============================================================================
/// app_colors.dart
/// -----------------------------------------------------------------------------
/// Paleta de colores oficial del Proyecto B (Control de Asistencias).
/// Apartado 4.2 (Lineamientos de identidad visual) del MPF.
///
/// La paleta base es neutral (multi-institución). Cada institución puede
/// sobre-escribir los colores primarios mediante AppTheme.fromInstitucion.
/// =============================================================================
library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Colores principales (Tabla 4 del MPF) – Marca GAMA
  // ---------------------------------------------------------------------------
  static const Color primary = Color(0xFF2E5BFF);
  static const Color primaryLight = Color(0xFF6B8AFF);
  static const Color primaryDark = Color(0xFF1B3DCC);

  // ---------------------------------------------------------------------------
  // Colores de acento (Tabla 5 del MPF)
  // ---------------------------------------------------------------------------
  static const Color accent = Color(0xFFFFB020);
  static const Color accentLight = Color(0xFFFFD27A);

  // ---------------------------------------------------------------------------
  // Colores de elementos de interfaz (Tabla 6 del MPF)
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDF0F4);
  static const Color border = Color(0xFFD8DCE2);
  static const Color divider = Color(0xFFE3E6EB);

  // ---------------------------------------------------------------------------
  // Tipografía y texto
  // ---------------------------------------------------------------------------
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF566174);
  static const Color textHint = Color(0xFF98A2B3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color link = Color(0xFF2E5BFF);

  // ---------------------------------------------------------------------------
  // Estados del sistema (Tabla 7 del MPF)
  // ---------------------------------------------------------------------------
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // ---------------------------------------------------------------------------
  // Estados de asistencia (RF-03 — historial codificado por colores)
  // verde = asistencia, rojo = falta, amarillo = justificada
  // ---------------------------------------------------------------------------
  static const Color asistencia = Color(0xFF2E7D32);
  static const Color falta = Color(0xFFD32F2F);
  static const Color justificada = Color(0xFFF9A825);
  static const Color sinRegistro = Color(0xFFB0BEC5);

  // ---------------------------------------------------------------------------
  // Variantes institucionales demo (RF-04)
  // ---------------------------------------------------------------------------
  static const Color tecPrimary = Color(0xFF143F73);
  static const Color tecAccent = Color(0xFFE85D04);

  static const Color uniPrimary = Color(0xFF6A1B9A);
  static const Color uniAccent = Color(0xFFFFC107);
}
