/// @file: grupo_model.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Modelos para los grupos del docente.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import '../../../core/widgets/attendance_status_chip.dart';
import '../../alumno/model/materia_model.dart';

class HorarioSesion {
  const HorarioSesion({
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  final String dia;
  final String horaInicio;
  final String horaFin;
}

class AlumnoGrupo {
  const AlumnoGrupo({
    required this.id,
    required this.nombre,
    required this.matricula,
    required this.asistencias,
    required this.totalSesiones,
    this.historial = const [],
  });

  final String id;
  final String nombre;
  final String matricula;
  final int asistencias;
  final int totalSesiones;
  final List<RegistroAsistencia> historial;

  double get porcentaje =>
      totalSesiones == 0 ? 0 : asistencias / totalSesiones;

  factory AlumnoGrupo.fromJson(Map<String, dynamic> json) {
    return AlumnoGrupo(
      id:            json['id'] ?? '',
      nombre:        '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      matricula:     json['email'] ?? '',
      asistencias:   json['asistencias'] ?? 0,
      totalSesiones: json['total_sesiones'] ?? 0,
    );
  }
}

class Grupo {
  const Grupo({
    required this.id,
    required this.nombre,
    required this.materia,
    required this.institucion,
    required this.periodoAcademico,
    required this.capacidadMaxima,
    required this.horarios,
    required this.alumnos,
    this.codigoMatriculacion,
  });

  final String id;
  final String nombre;
  final String materia;
  final String institucion;
  final String periodoAcademico;
  final int capacidadMaxima;
  final List<HorarioSesion> horarios;
  final List<AlumnoGrupo> alumnos;
  final String? codigoMatriculacion;

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id:               json['id'] ?? '',
      nombre:           json['subject_name'] ?? '',
      materia:          json['subject_name'] ?? '',
      institucion:      json['institution_id'] ?? '',
      periodoAcademico: json['period'] ?? '',
      capacidadMaxima:  json['max_capacity'] ?? 30,
      horarios:         const [],
      alumnos:          [],
      codigoMatriculacion: json['id'],
    );
  }
}