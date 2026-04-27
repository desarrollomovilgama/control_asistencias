/// =============================================================================
/// auth_service.dart
/// -----------------------------------------------------------------------------
/// Esqueleto del servicio de autenticación. La maqueta usa el catálogo de
/// credenciales DEMO (lib/core/auth/credenciales_demo.dart). Aquí dejamos
/// la firma para conectar el backend real (PayPal-protected o WS GAMA).
/// =============================================================================
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const _storage = FlutterSecureStorage();
  static const String _kTokenKey = 'gama_access_token';

  Future<String?> leerToken() => _storage.read(key: _kTokenKey);

  Future<void> guardarToken(String token) =>
      _storage.write(key: _kTokenKey, value: token);

  Future<void> borrarToken() => _storage.delete(key: _kTokenKey);

  // TODO: implementar login() / logout() / refresh() contra el backend real.
}
