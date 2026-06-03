/// @file: institucion_model.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Modelo de institución del docente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class Institucion {
  const Institucion({
    required this.id,
    required this.nombre,
    this.logoUrl,
    this.colorPrimario = AppColors.primary,
  });

  final String id;
  final String nombre;
  final String? logoUrl;
  final Color colorPrimario;

  factory Institucion.fromJson(Map<String, dynamic> json) {
    return Institucion(
      id:      json['id']?.toString() ?? '',
      nombre:  json['name']?.toString() ?? '',
      logoUrl: json['logo_url']?.toString(),
    );
  }

  String get inicial =>
      nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
}