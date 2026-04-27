/// =============================================================================
/// notificaciones_viewmodel.dart
/// -----------------------------------------------------------------------------
/// ViewModel del centro de notificaciones (RF-10 / RF-11 / RF-12).
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../model/notificacion_model.dart';

class NotificacionesViewModel extends ChangeNotifier {
  bool _cargando = false;
  List<Notificacion> _items = [];

  bool get cargando => _cargando;
  List<Notificacion> get items => _items;
  int get noLeidas => _items.where((n) => !n.leida).length;

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _items = NotificacionesDemo.catalogo();
    _cargando = false;
    notifyListeners();
  }
}
