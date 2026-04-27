/// =============================================================================
/// grupo_model.dart
/// -----------------------------------------------------------------------------
/// Modelos para los grupos del docente (RF-01, RF-06, RF-08).
/// =============================================================================
library;

import '../../../core/widgets/attendance_status_chip.dart';
import '../../alumno/model/materia_model.dart';

class HorarioSesion {
  const HorarioSesion({
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  final String dia; // "Lun", "Mar"...
  final String horaInicio; // "07:00"
  final String horaFin; // "08:30"
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
}

class GruposDemo {
  GruposDemo._();

  static List<Grupo> catalogoTec() => [
        Grupo(
          id: 'tec-pm-a',
          nombre: 'Grupo A',
          materia: 'Programación móvil',
          institucion: 'Instituto Tecnológico',
          periodoAcademico: '2026-1',
          capacidadMaxima: 30,
          codigoMatriculacion: 'ITT-PM-A26',
          horarios: const [
            HorarioSesion(dia: 'Lun', horaInicio: '07:00', horaFin: '08:30'),
            HorarioSesion(dia: 'Mié', horaInicio: '07:00', horaFin: '08:30'),
          ],
          alumnos: [
            AlumnoGrupo(
              id: 'A1',
              nombre: 'Ana Pérez',
              matricula: '21AT001',
              asistencias: 19,
              totalSesiones: 24,
              historial: _historialMock(),
            ),
            AlumnoGrupo(
              id: 'A2',
              nombre: 'Luis Gómez',
              matricula: '21AT002',
              asistencias: 14,
              totalSesiones: 24,
              historial: _historialMock(),
            ),
          ],
        ),
      ];

  static List<Grupo> catalogoUniversidad() => [
        Grupo(
          id: 'uni-bd-1',
          nombre: 'BD-101',
          materia: 'Bases de datos',
          institucion: 'Universidad',
          periodoAcademico: '2026-Primavera',
          capacidadMaxima: 50,
          codigoMatriculacion: 'UNI-BD-26P',
          horarios: const [
            HorarioSesion(dia: 'Mar', horaInicio: '09:00', horaFin: '11:00'),
            HorarioSesion(dia: 'Jue', horaInicio: '09:00', horaFin: '11:00'),
          ],
          alumnos: [
            AlumnoGrupo(
              id: 'U1',
              nombre: 'Karla Hernández',
              matricula: 'UN20251',
              asistencias: 18,
              totalSesiones: 20,
              historial: _historialMock(),
            ),
          ],
        ),
      ];

  static List<RegistroAsistencia> _historialMock() {
    final ahora = DateTime.now();
    return List.generate(10, (i) {
      return RegistroAsistencia(
        fecha: ahora.subtract(Duration(days: i)),
        estado: i % 4 == 0 ? EstadoAsistencia.falta : EstadoAsistencia.asistencia,
      );
    });
  }
}
