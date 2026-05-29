/// @file: materia_model.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Modelos del dashboard del alumno. Sin mocks.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import '../../../core/widgets/attendance_status_chip.dart';

class RegistroAsistencia {
  const RegistroAsistencia({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.materia,
  });

  final String id;
  final DateTime fecha;
  final EstadoAsistencia estado;
  final String materia;

  factory RegistroAsistencia.fromJson(Map<String, dynamic> json) {
    return RegistroAsistencia(
      id: json['id'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      estado: _parseEstado(json['estado']),
      materia: json['materia'] ?? '',
    );
  }

  static EstadoAsistencia _parseEstado(String? estado) {
    switch (estado) {
      case 'present':
        return EstadoAsistencia.asistencia;
      case 'justified':
        return EstadoAsistencia.justificada;
      case 'absent':
      default:
        return EstadoAsistencia.falta;
    }
  }
}

class Materia {
  const Materia({
    required this.id,
    required this.nombre,
    required this.docente,
    required this.institucion,
    required this.totalSesiones,
    required this.asistencias,
    required this.justificadas,
    required this.faltas,
    required this.umbralMinimo,
    this.historial = const [],
    this.periodo,
  });

  final String id;
  final String nombre;
  final String docente;
  final String institucion;
  final int totalSesiones;
  final int asistencias;
  final int justificadas;
  final int faltas;
  final double umbralMinimo;
  final List<RegistroAsistencia> historial;
  final String? periodo;

  double get porcentajeAsistencia {
    if (totalSesiones == 0) return 0;
    return (asistencias + justificadas) / totalSesiones;
  }

  bool get cumpleUmbral => porcentajeAsistencia >= umbralMinimo;

  int get totalRegistrado => asistencias + justificadas + faltas;

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id:            json['id'] ?? '',
      nombre:        json['nombre'] ?? '',
      docente:       json['docente'] ?? '',
      institucion:   json['institucion'] ?? '',
      totalSesiones: json['total_sesiones'] ?? 0,
      asistencias:   json['asistencias'] ?? 0,
      justificadas:  json['justificadas'] ?? 0,
      faltas:        json['faltas'] ?? 0,
      umbralMinimo:  (json['umbral_minimo'] ?? 0.8).toDouble(),
      periodo:       json['periodo'],
    );
  }
}