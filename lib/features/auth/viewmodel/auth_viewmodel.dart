/// @file: auth_viewmodel.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: ViewModel del módulo de autenticación.
/// @version: 1.2.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/foundation.dart';
import 'package:control_asistencias/services/auth_service.dart';

import '../../../core/session/session_service.dart';
import '../model/usuario_model.dart';

enum LoginEstado { idle, cargando, exito, error }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._session);

  final SessionService _session;

  LoginEstado _estado = LoginEstado.idle;
  String?     _error;
  Usuario?    _usuario;

  LoginEstado get estado  => _estado;
  String?     get error   => _error;
  Usuario?    get usuario => _usuario;
  bool        get cargando => _estado == LoginEstado.cargando;

  Future<bool> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    final c = correo.trim();
    if (c.isEmpty || password.isEmpty) {
      _setError('Correo y contraseña son obligatorios.');
      return false;
    }

    _estado = LoginEstado.cargando;
    _error  = null;
    notifyListeners();

    try {
      final result = await AuthService.login(email: c, password: password);

      if (result['success'] == true) {
        final data = result['data']['user'];
        _usuario = Usuario(
          id:             data['id']?.toString() ?? '',
          nombreCompleto: '${data['first_name']} ${data['last_name']}',
          correo:         c,
          tipo: data['role'] == 'docente'
              ? TipoUsuario.docente
              : TipoUsuario.alumno,
        );
        _session.setUsuario(_usuario!);
        _estado = LoginEstado.exito;
        notifyListeners();
        return true;
      }

      _setError(result['message'] ?? 'Credenciales inválidas.');
      return false;
    } catch (e) {
      _setError('Error inesperado. Intenta de nuevo.');
      return false;
    }
  }

  Future<bool> registrar({
    required String    nombre,
    required String    correo,
    required String    password,
    required TipoUsuario tipo,
    String? institutionCode, // Obligatorio para docente
    String? invitationCode,  // Opcional para alumno
  }) async {
    if (nombre.trim().isEmpty || correo.trim().isEmpty || password.isEmpty) {
      _setError('Todos los campos son obligatorios.');
      return false;
    }
    if (password.length < 6) {
      _setError('La contraseña debe tener al menos 6 caracteres.');
      return false;
    }
    if (tipo == TipoUsuario.docente &&
        (institutionCode == null || institutionCode.trim().isEmpty)) {
      _setError('El código de institución es obligatorio para docentes.');
      return false;
    }

    _estado = LoginEstado.cargando;
    _error  = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        name:            nombre.trim(),
        email:           correo.trim(),
        password:        password,
        role:            tipo == TipoUsuario.docente ? 'docente' : 'alumno',
        institutionCode: institutionCode,
        invitationCode:  invitationCode,
      );

      if (result['success'] == true) {
        _usuario = Usuario(
          id:             result['data']['user']['id']?.toString() ?? '',
          nombreCompleto: nombre.trim(),
          correo:         correo.trim(),
          tipo:           tipo,
        );
        _session.setUsuario(_usuario!);
        _estado = LoginEstado.exito;
        notifyListeners();
        return true;
      }

      _setError(result['message'] ?? 'Error al registrar.');
      return false;
    } catch (e) {
      _setError('Error inesperado. Intenta de nuevo.');
      return false;
    }
  }

  void cerrarSesion() {
    _usuario = null;
    _session.logout();
    _estado  = LoginEstado.idle;
    notifyListeners();
  }

  void _setError(String mensaje) {
    _estado = LoginEstado.error;
    _error  = mensaje;
    notifyListeners();
  }

  void resetEstado() {
    _estado = LoginEstado.idle;
    _error  = null;
    notifyListeners();
  }
}