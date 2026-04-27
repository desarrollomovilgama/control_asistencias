/// =============================================================================
/// grupos_viewmodel.dart
/// -----------------------------------------------------------------------------
/// ViewModel para los grupos del docente. Devuelve el catálogo según la
/// institución activa (RF-04).
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../../../core/session/session_service.dart';
import '../../instituciones/model/institucion_model.dart';
import '../model/grupo_model.dart';

class GruposViewModel extends ChangeNotifier {
  GruposViewModel(this._session);

  final SessionService _session;

  bool _cargando = false;
  List<Grupo> _grupos = [];

  bool get cargando => _cargando;
  List<Grupo> get grupos => _grupos;
  Institucion? get institucion => _session.institucionActiva;

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final inst = _session.institucionActiva;
    if (inst == null || inst.esTec) {
      _grupos = GruposDemo.catalogoTec();
    } else {
      _grupos = GruposDemo.catalogoUniversidad();
    }
    _cargando = false;
    notifyListeners();
  }
}
