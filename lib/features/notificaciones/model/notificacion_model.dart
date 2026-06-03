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

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id:      json['id']?.toString() ?? '',
      tipo:    _parseTipo(json['type']?.toString()),
      titulo:  json['titulo']?.toString() ?? '',
      mensaje: json['mensaje']?.toString() ?? '',
      fecha:   DateTime.tryParse(json['sent_at'] ?? '') ?? DateTime.now(),
      leida:   json['leida'] == true,
    );
  }

  static TipoNotificacion _parseTipo(String? tipo) {
    switch (tipo) {
      case 'RIESGO_REPROBACION':    return TipoNotificacion.alertaPreventiva;
      case 'ALERTA_PREVENTIVA':     return TipoNotificacion.alertaPreventiva;
      case 'SESION_ABIERTA':        return TipoNotificacion.recordatorioClase;
      case 'JUSTIFICANTE_APROBADO': return TipoNotificacion.estadoJustificante;
      case 'JUSTIFICANTE_RECHAZADO':return TipoNotificacion.estadoJustificante;
      case 'INASISTENCIA':          return TipoNotificacion.inasistencia;
      default:                      return TipoNotificacion.inasistencia;
    }
  }
}
