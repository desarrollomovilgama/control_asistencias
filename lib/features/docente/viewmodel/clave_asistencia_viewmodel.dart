/// =============================================================================
/// clave_asistencia_viewmodel.dart
/// -----------------------------------------------------------------------------
/// ViewModel del generador de clave de asistencia (RF-01).
/// Genera una clave alfanumérica única y expone un toggle de apertura/cierre.
/// =============================================================================
library;

import 'dart:math';

import 'package:flutter/foundation.dart';

class ClaveAsistenciaViewModel extends ChangeNotifier {
  static const String _abc = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final Random _rng = Random();

  String? _clave;
  bool _abierta = false;
  int _registrados = 0;
  bool _dentroDeHorario = true; // mock

  String? get clave => _clave;
  bool get abierta => _abierta;
  int get registrados => _registrados;
  bool get dentroDeHorario => _dentroDeHorario;

  String _generar() {
    final buf = StringBuffer();
    for (var i = 0; i < 8; i++) {
      buf.write(_abc[_rng.nextInt(_abc.length)]);
    }
    return buf.toString();
  }

  void abrir() {
    if (!_dentroDeHorario) return;
    _clave = _generar();
    _abierta = true;
    _registrados = 0;
    notifyListeners();
  }

  void cerrar() {
    _abierta = false;
    notifyListeners();
  }

  void simularRegistro() {
    if (_abierta) {
      _registrados++;
      notifyListeners();
    }
  }

  /// Útil para demostrar el rechazo "fuera de horario".
  void alternarHorario() {
    _dentroDeHorario = !_dentroDeHorario;
    if (!_dentroDeHorario) cerrar();
    notifyListeners();
  }
}
