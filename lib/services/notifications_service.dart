/// =============================================================================
/// notifications_service.dart
/// -----------------------------------------------------------------------------
/// Esqueleto del servicio de notificaciones push (RF-10 / RF-11 / RF-12).
/// La maqueta sólo expone una API; la conexión real (FCM / APNs) se hará
/// en una iteración posterior cuando esté el backend en Heroku.
/// =============================================================================
library;

class NotificationsService {
  NotificationsService._internal();
  static final NotificationsService instance =
      NotificationsService._internal();

  Future<void> inicializar() async {
    // TODO: registrar token FCM y configurar canales de Android.
  }

  Future<void> programarRecordatorioClase({
    required String materia,
    required DateTime inicioClase,
  }) async {
    // RF-10: 10 minutos antes del inicio.
  }

  Future<void> notificarInasistencia({
    required String materia,
    required DateTime sesion,
  }) async {
    // RF-11.
  }

  Future<void> alertaPreventiva({
    required String rubro,
    required String materia,
  }) async {
    // RF-12: "Una falta más y no alcanzas el porcentaje para [rubro]".
  }
}
