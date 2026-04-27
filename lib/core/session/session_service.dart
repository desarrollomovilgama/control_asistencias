/// =============================================================================
/// session_service.dart
/// -----------------------------------------------------------------------------
/// Servicio global de sesión basado en ChangeNotifier (apartado 4.3 del MPF).
/// Mantiene el usuario autenticado y el espacio (institución) activo durante
/// toda la ejecución de la app y notifica a las vistas cuando cambian.
///
/// En esta maqueta solo guarda en memoria. La persistencia real
/// (Hive + flutter_secure_storage) se conectará en una iteración posterior.
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../../features/auth/model/usuario_model.dart';
import '../../features/instituciones/model/institucion_model.dart';

class SessionService extends ChangeNotifier {
  Usuario? _usuario;
  Institucion? _institucionActiva;

  Usuario? get usuario => _usuario;
  Institucion? get institucionActiva => _institucionActiva;

  bool get autenticado => _usuario != null;
  TipoUsuario get rol => _usuario?.tipo ?? TipoUsuario.desconocido;

  bool get esAlumno => _usuario?.esAlumno ?? false;
  bool get esDocente => _usuario?.esDocente ?? false;

  /// Asigna el usuario tras un login exitoso.
  void setUsuario(Usuario u) {
    _usuario = u;
    _institucionActiva = null;
    notifyListeners();
  }

  /// Cambia la institución/espacio activo del docente (RF-04).
  void setInstitucionActiva(Institucion? inst) {
    _institucionActiva = inst;
    notifyListeners();
  }

  /// Cierre de sesión.
  void logout() {
    _usuario = null;
    _institucionActiva = null;
    notifyListeners();
  }
}
