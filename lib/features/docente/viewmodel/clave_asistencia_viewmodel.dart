/// @file: clave_asistencia_viewmodel.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: ViewModel del generador de clave de asistencia. Datos reales.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/foundation.dart';
import '../../../services/docente_service.dart';

class ClaveAsistenciaViewModel extends ChangeNotifier {
  String? _classroomId;
  String? _sessionId;
  String? _clave;
  bool _abierta = false;
  bool _cargando = false;
  int _registrados = 0;
  String? _error;

  String? get classroomId => _classroomId;
  String? get sessionId => _sessionId;
  String? get clave => _clave;
  bool get abierta => _abierta;
  bool get cargando => _cargando;
  int get registrados => _registrados;
  String? get error => _error;

  void seleccionarGrupo(String classroomId) {
    _classroomId = classroomId;
    _sessionId = null;
    _clave = null;
    _abierta = false;
    _registrados = 0;
    _error = null;
    notifyListeners();
  }

  Future<void> abrirSesion() async {
    if (_classroomId == null) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    final result = await DocenteService.abrirSesion(
      classroomId: _classroomId!,
    );

    if (result['success'] == true) {
      _sessionId = result['data']['id'];
      await generarClave();
    } else {
      _error = result['message'];
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> generarClave() async {
    if (_sessionId == null) {
      await abrirSesion();
      return;
    }

    _cargando = true;
    _error = null;
    notifyListeners();

    final result = await DocenteService.generarClave(
      sessionId: _sessionId!,
    );

    if (result['success'] == true) {
      _clave = result['data']['access_key'];
      _abierta = true;
      _registrados = 0;
    } else {
      _error = result['message'];
    }

    _cargando = false;
    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    if (_sessionId == null) return;

    _cargando = true;
    notifyListeners();

    final result = await DocenteService.cerrarSesion(
      sessionId: _sessionId!,
    );

    if (result['success'] == true) {
      _abierta = false;
      _clave = null;
      _sessionId = null;
    } else {
      _error = result['message'];
    }

    _cargando = false;
    notifyListeners();
  }
}