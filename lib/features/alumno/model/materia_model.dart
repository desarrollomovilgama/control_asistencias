/// =============================================================================
/// materia_model.dart
/// -----------------------------------------------------------------------------
/// Modelos del dashboard del alumno (RF-03).
/// =============================================================================
library;

import '../../../core/widgets/attendance_status_chip.dart';

class RegistroAsistencia {
  const RegistroAsistencia({
    required this.fecha,
    required this.estado,
    this.nota,
  });

  final DateTime fecha;
  final EstadoAsistencia estado;
  final String? nota;
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
    required this.historial,
    this.codigoColor,
    this.codigoMateria = 'ABC-123',
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
  final String? codigoColor;
  final String codigoMateria;

  /// (Asistencias + Justificantes) / Total de clases (RF-03).
  double get porcentajeAsistencia {
    if (totalSesiones == 0) return 0;
    return (asistencias + justificadas) / totalSesiones;
  }

  bool get cumpleUmbral => porcentajeAsistencia >= umbralMinimo;

  int get totalRegistrado => asistencias + justificadas + faltas;
}

class MateriasDemo {
  MateriasDemo._();

  static List<Materia> catalogo() => <Materia>[
        Materia(
          id: 'mat-1',
          nombre: 'Programación móvil',
          docente: 'Mauro Sánchez',
          institucion: 'Instituto Tecnológico',
          totalSesiones: 24,
          asistencias: 19,
          justificadas: 2,
          faltas: 3,
          umbralMinimo: 0.80,
          historial: _historialMock(),
          codigoMateria: 'PM-2024',
        ),
        Materia(
          id: 'mat-2',
          nombre: 'Bases de datos',
          docente: 'Gamaliel Castro',
          institucion: 'Universidad',
          totalSesiones: 20,
          asistencias: 13,
          justificadas: 1,
          faltas: 6,
          umbralMinimo: 0.80,
          historial: _historialMock(),
          codigoMateria: 'BD-I8',
        ),
      ];

  static List<RegistroAsistencia> _historialMock() {
    final ahora = DateTime.now();
    return List.generate(8, (i) {
      EstadoAsistencia estado = switch (i % 4) {
        0 => EstadoAsistencia.asistencia,
        1 => EstadoAsistencia.asistencia,
        2 => EstadoAsistencia.falta,
        _ => EstadoAsistencia.justificada,
      };
      return RegistroAsistencia(
        fecha: ahora.subtract(Duration(days: i)),
        estado: estado,
      );
    });
  }
}
