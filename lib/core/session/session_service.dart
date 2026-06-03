/// @file: session_service.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Servicio global de sesión con persistencia.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../features/auth/model/usuario_model.dart';
import '../../features/instituciones/model/institucion_model.dart';
import '../../services/api_client.dart';

class SessionService extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _keyUsuario = 'session_usuario';

  Usuario?    _usuario;
  Institucion? _institucionActiva;

  Usuario?    get usuario          => _usuario;
  Institucion? get institucionActiva => _institucionActiva;

  bool get autenticado => _usuario != null;
  TipoUsuario get rol  => _usuario?.tipo ?? TipoUsuario.desconocido;
  bool get esAlumno    => _usuario?.esAlumno ?? false;
  bool get esDocente   => _usuario?.esDocente ?? false;

  /// Carga la sesión guardada al iniciar la app.
  Future<bool> cargarSesion() async {
    try {
      final token = await _storage.read(key: 'sanctum_token');
      if (token == null) return false;

      final userData = await _storage.read(key: _keyUsuario);
      if (userData == null) return false;

      final json = jsonDecode(userData) as Map<String, dynamic>;
      _usuario = Usuario(
        id:             json['id'] ?? '',
        nombreCompleto: json['nombreCompleto'] ?? '',
        correo:         json['correo'] ?? '',
        tipo: json['tipo'] == 'docente'
            ? TipoUsuario.docente
            : TipoUsuario.alumno,
      );

      await ApiClient.setAuthToken();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Asigna el usuario tras un login exitoso y persiste.
  Future<void> setUsuario(Usuario u) async {
    _usuario = u;
    _institucionActiva = null;

    await _storage.write(
      key: _keyUsuario,
      value: jsonEncode({
        'id':             u.id,
        'nombreCompleto': u.nombreCompleto,
        'correo':         u.correo,
        'tipo':           u.esDocente ? 'docente' : 'alumno',
      }),
    );

    notifyListeners();
  }

  /// Cambia la institución activa del docente.
  void setInstitucionActiva(Institucion? inst) {
    _institucionActiva = inst;
    notifyListeners();
  }

  /// Cierre de sesión — limpia storage.
  Future<void> logout() async {
    _usuario          = null;
    _institucionActiva = null;
    await _storage.delete(key: 'sanctum_token');
    await _storage.delete(key: _keyUsuario);
    ApiClient.clearAuthToken();
    notifyListeners();
  }
}