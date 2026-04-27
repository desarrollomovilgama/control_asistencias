/// =============================================================================
/// connectivity_service.dart
/// -----------------------------------------------------------------------------
/// Detección de conectividad (RF-13). Usa connectivity_plus.
/// La integración para mostrar la pantalla "Sin conexión" automáticamente
/// se conectará desde el navegador / interceptor más adelante.
/// =============================================================================
library;

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._internal();
  static final ConnectivityService instance = ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get cambios =>
      _connectivity.onConnectivityChanged;

  Future<bool> hayConexion() async {
    final r = await _connectivity.checkConnectivity();
    return !r.contains(ConnectivityResult.none);
  }
}
