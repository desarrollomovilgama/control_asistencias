/// @file: grupo_model.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Modelos para los grupos del docente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;


class AlumnoGrupo {
  const AlumnoGrupo({
    required this.id,
    required this.enrollmentId,
    required this.nombre,
    required this.matricula,
    required this.asistencias,
    required this.totalSesiones,
  });

  final String id;
  final String enrollmentId;
  final String nombre;
  final String matricula;
  final int asistencias;
  final int totalSesiones;

  double get porcentaje =>
      totalSesiones == 0 ? 0 : asistencias / totalSesiones;

  factory AlumnoGrupo.fromJson(Map<String, dynamic> json) {
    return AlumnoGrupo(
      id:            json['id']?.toString() ?? '',
      enrollmentId:  json['enrollment_id']?.toString() ?? '',
      nombre:        '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      matricula:     json['email']?.toString() ?? '',
      asistencias:   json['asistencias'] ?? 0,
      totalSesiones: json['total_sesiones'] ?? 0,
    );
  }
}

class Grupo {
  const Grupo({
    required this.id,
    required this.nombre,
    required this.periodoAcademico,
    required this.umbralMinimo,
    this.alumnosCount = 0,
  });

  final String id;
  final String nombre;
  final String periodoAcademico;
  final int umbralMinimo;
  final int alumnosCount;

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id:               json['id']?.toString() ?? '',
      nombre:           json['subject_name']?.toString() ?? '',
      periodoAcademico: json['period']?.toString() ?? '',
      umbralMinimo:     json['min_attendance_pct'] ?? 80,
      alumnosCount:     json['alumnos_count'] ?? 0,
    );
  }
}