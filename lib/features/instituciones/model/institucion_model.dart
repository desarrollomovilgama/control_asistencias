/// =============================================================================
/// institucion_model.dart
/// -----------------------------------------------------------------------------
/// Modelo de "espacio" / institución del docente (RF-04, RF-05).
/// Cada institución tiene rubros y porcentajes independientes.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum TipoInstitucion { tec, universidad, otro }

class RubroEvaluacion {
  const RubroEvaluacion({
    required this.nombre,
    required this.porcentajeMinimo,
  });

  final String nombre; // Ej: "Ordinario", "Extraordinario", "Complementario"
  final double porcentajeMinimo; // 0.0 – 1.0

  RubroEvaluacion copyWith({String? nombre, double? porcentajeMinimo}) {
    return RubroEvaluacion(
      nombre: nombre ?? this.nombre,
      porcentajeMinimo: porcentajeMinimo ?? this.porcentajeMinimo,
    );
  }
}

class Institucion {
  const Institucion({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.rubros,
    required this.colorPrimario,
    this.urlLogo,
    this.diasJustificantePosterior = 7,
  });

  final String id;
  final String nombre;
  final TipoInstitucion tipo;
  final List<RubroEvaluacion> rubros;
  final Color colorPrimario;
  final String? urlLogo;

  /// Días que el alumno tiene para entregar el justificante después de
  /// regresar (entrevista — Universidad: 7, TEC: notificación inmediata).
  final int diasJustificantePosterior;

  bool get esTec => tipo == TipoInstitucion.tec;
  bool get esUniversidad => tipo == TipoInstitucion.universidad;
}

/// Catálogo demo (mientras no hay backend).
class InstitucionesDemo {
  InstitucionesDemo._();

  static const Institucion tec = Institucion(
    id: 'inst-tec',
    nombre: 'Instituto Tecnológico',
    tipo: TipoInstitucion.tec,
    rubros: [RubroEvaluacion(nombre: 'Complementario', porcentajeMinimo: 0.80)],
    colorPrimario: AppColors.tecPrimary,
    urlLogo: 'assets/images/logo_tec.png',
    diasJustificantePosterior: 0,
  );

  static const Institucion universidad = Institucion(
    id: 'inst-uni',
    nombre: 'Universidad',
    tipo: TipoInstitucion.universidad,
    rubros: [
      RubroEvaluacion(nombre: 'Ordinario', porcentajeMinimo: 0.80),
      RubroEvaluacion(nombre: 'Extraordinario', porcentajeMinimo: 0.60),
      RubroEvaluacion(nombre: 'Título', porcentajeMinimo: 0.20),
    ],
    colorPrimario: AppColors.uniPrimary,
    urlLogo: 'assets/images/logo_universidad.png',
    diasJustificantePosterior: 7,
  );

  static const List<Institucion> catalogo = [tec, universidad];
}
