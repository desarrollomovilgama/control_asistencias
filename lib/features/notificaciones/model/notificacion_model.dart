/// =============================================================================
/// notificacion_model.dart
/// -----------------------------------------------------------------------------
/// Modelo de notificación push para RF-10 / RF-11 / RF-12.
/// =============================================================================
library;

enum TipoNotificacion {
  recordatorioClase,    // RF-10
  inasistencia,         // RF-11
  estadoJustificante,   // RF-09
  alertaPreventiva,     // RF-12
  membresia,
}

class Notificacion {
  const Notificacion({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.mensaje,
    required this.fecha,
    this.leida = false,
  });

  final String id;
  final TipoNotificacion tipo;
  final String titulo;
  final String mensaje;
  final DateTime fecha;
  final bool leida;
}

class NotificacionesDemo {
  NotificacionesDemo._();

  static List<Notificacion> catalogo() {
    final ahora = DateTime.now();
    return [
      Notificacion(
        id: 'n1',
        tipo: TipoNotificacion.recordatorioClase,
        titulo: 'Tu clase comienza en 10 minutos',
        mensaje: 'Programación móvil — Aula 12',
        fecha: ahora.subtract(const Duration(minutes: 8)),
      ),
      Notificacion(
        id: 'n2',
        tipo: TipoNotificacion.alertaPreventiva,
        titulo: 'Una falta más y no alcanzas el porcentaje para Ordinario',
        mensaje: 'Bases de datos — Universidad',
        fecha: ahora.subtract(const Duration(hours: 2)),
      ),
      Notificacion(
        id: 'n3',
        tipo: TipoNotificacion.estadoJustificante,
        titulo: 'Justificante aceptado',
        mensaje: 'Programación móvil — Falta del 12 de abril',
        fecha: ahora.subtract(const Duration(days: 1)),
        leida: true,
      ),
      Notificacion(
        id: 'n4',
        tipo: TipoNotificacion.inasistencia,
        titulo: 'Falta registrada',
        mensaje: 'Estructura de datos — sesión del lunes',
        fecha: ahora.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
