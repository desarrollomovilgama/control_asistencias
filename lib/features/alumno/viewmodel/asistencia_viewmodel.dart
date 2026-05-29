/// @file: asistencia_viewmodel.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: ViewModel del registro de asistencia del alumno. Datos reales.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/foundation.dart';
import '../../../services/alumno_service.dart';

enum EnvioEstado { idle, enviando, exito, duplicado, claveInvalida, sinSesion, error }

class AsistenciaViewModel extends ChangeNotifier {
  EnvioEstado _estado = EnvioEstado.idle;
  String? _mensajeError;

  EnvioEstado get estado => _estado;
  String? get mensajeError => _mensajeError;
  bool get enviando => _estado == EnvioEstado.enviando;
  bool get yaRegistrado => _estado == EnvioEstado.exito;

  Future<void> enviarClave(String claveIngresada) async {
    if (claveIngresada.trim().isEmpty) {
      _estado = EnvioEstado.claveInvalida;
      _mensajeError = 'Ingresa la clave de la sesión.';
      notifyListeners();
      return;
    }

    _estado = EnvioEstado.enviando;
    _mensajeError = null;
    notifyListeners();

    final result = await AlumnoService.registrarAsistencia(
      accessKey: claveIngresada.trim().toUpperCase(),
    );

    if (result['success'] == true) {
      _estado = EnvioEstado.exito;
    } else {
      final mensaje = result['message'] ?? '';

      if (mensaje.contains('expiró') || mensaje.contains('cerró')) {
        _estado = EnvioEstado.sinSesion;
      } else if (mensaje.contains('Ya registraste')) {
        _estado = EnvioEstado.duplicado;
      } else if (mensaje.contains('inválida') || mensaje.contains('No encontrado')) {
        _estado = EnvioEstado.claveInvalida;
      } else {
        _estado = EnvioEstado.error;
      }

      _mensajeError = mensaje;
    }

    notifyListeners();
  }

  void reset() {
    _estado = EnvioEstado.idle;
    _mensajeError = null;
    notifyListeners();
  }
}