/// =============================================================================
/// auth_viewmodel.dart
/// -----------------------------------------------------------------------------
/// ViewModel del módulo de autenticación. Apartado 4.3 del MPF.
/// SOLO MAQUETA: valida dominio institucional y autentica contra el catálogo
/// de credenciales DEMO. La integración real con backend se conecta luego.
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../../../core/auth/credenciales_demo.dart';
import '../../../core/session/session_service.dart';
import '../model/usuario_model.dart';

enum LoginEstado { idle, cargando, exito, error }

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._session);

  final SessionService _session;

  LoginEstado _estado = LoginEstado.idle;
  String? _error;
  Usuario? _usuario;

  LoginEstado get estado => _estado;
  String? get error => _error;
  Usuario? get usuario => _usuario;
  bool get cargando => _estado == LoginEstado.cargando;

  /// Inicio de sesión (mock).
  ///   1. Valida que ambos campos no estén vacíos.
  ///   2. Valida que el correo sea de un dominio aceptado.
  ///   3. Busca la credencial en el catálogo demo.
  ///   4. Si coincide, guarda el usuario en SessionService.
  Future<bool> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    final c = correo.trim();

    if (c.isEmpty || password.isEmpty) {
      _setError('Correo y contraseña son obligatorios.');
      return false;
    }

    if (!tieneDominioInstitucional(c)) {
      _setError(
        'El correo debe terminar en uno de los dominios institucionales.',
      );
      return false;
    }

    _estado = LoginEstado.cargando;
    _error = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    final cred = buscarCredencial(correo: c, password: password);
    if (cred == null) {
      _setError('Credenciales inválidas. Verifica correo y contraseña.');
      return false;
    }

    _usuario = cred.usuario;
    _session.setUsuario(cred.usuario);
    _estado = LoginEstado.exito;
    notifyListeners();
    return true;
  }

  /// Registro de nueva cuenta (mock — no persiste).
  Future<bool> registrar({
    required String nombre,
    required String correo,
    required String password,
    required TipoUsuario tipo,
  }) async {
    if (nombre.trim().isEmpty || correo.trim().isEmpty || password.isEmpty) {
      _setError('Todos los campos son obligatorios.');
      return false;
    }
    if (password.length < 8) {
      _setError('La contraseña debe tener al menos 8 caracteres.');
      return false;
    }
    if (!tieneDominioInstitucional(correo)) {
      _setError('El correo debe ser institucional.');
      return false;
    }

    _estado = LoginEstado.cargando;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 700));

    _usuario = Usuario(
      id: 'NEW-${DateTime.now().millisecondsSinceEpoch}',
      nombreCompleto: nombre.trim(),
      correo: correo.trim(),
      tipo: tipo,
    );
    _session.setUsuario(_usuario!);
    _estado = LoginEstado.exito;
    notifyListeners();
    return true;
  }

  void cerrarSesion() {
    _usuario = null;
    _session.logout();
    _estado = LoginEstado.idle;
    notifyListeners();
  }

  void _setError(String mensaje) {
    _estado = LoginEstado.error;
    _error = mensaje;
    notifyListeners();
  }

  void resetEstado() {
    _estado = LoginEstado.idle;
    _error = null;
    notifyListeners();
  }
}
