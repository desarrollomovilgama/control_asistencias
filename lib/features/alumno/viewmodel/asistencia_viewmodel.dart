/// =============================================================================
/// asistencia_viewmodel.dart
/// -----------------------------------------------------------------------------
/// ViewModel del envío de clave de asistencia por el alumno (RF-02).
/// Reglas (maqueta):
///   - La clave demo válida es "GAMA1234" mientras la sesión esté abierta.
///   - El alumno no puede enviar dos veces la misma clave (RF-02).
///   - Si no hay sesión activa, no se puede enviar.
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

enum EnvioEstado { idle, enviando, exito, duplicado, claveInvalida, sinSesion }

class AsistenciaViewModel extends ChangeNotifier {
  bool _sesionAbierta = true; // En la maqueta el toggle siempre arranca abierto
  String _claveValida = 'GAMA1234';
  EnvioEstado _estado = EnvioEstado.idle;
  bool _yaRegistrado = false;

  bool get sesionAbierta => _sesionAbierta;
  EnvioEstado get estado => _estado;
  bool get yaRegistrado => _yaRegistrado;
  bool get enviando => _estado == EnvioEstado.enviando;

  /// Para pruebas o cuando se invalida la sesión desde el lado del docente.
  void cerrarSesion() {
    _sesionAbierta = false;
    notifyListeners();
  }

  void abrirSesion(String nuevaClave) {
    _sesionAbierta = true;
    _claveValida = nuevaClave;
    _yaRegistrado = false;
    notifyListeners();
  }

  Future<void> enviarClave(String claveIngresada) async {
    if (!_sesionAbierta) {
      _estado = EnvioEstado.sinSesion;
      notifyListeners();
      return;
    }
    if (_yaRegistrado) {
      _estado = EnvioEstado.duplicado;
      notifyListeners();
      return;
    }

    _estado = EnvioEstado.enviando;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (claveIngresada.trim().toUpperCase() == _claveValida.toUpperCase()) {
      _yaRegistrado = true;
      _estado = EnvioEstado.exito;
    } else {
      _estado = EnvioEstado.claveInvalida;
    }
    notifyListeners();
  }

  void reset() {
    _estado = EnvioEstado.idle;
    notifyListeners();
  }
}
