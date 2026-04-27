/// =============================================================================
/// instituciones_viewmodel.dart
/// -----------------------------------------------------------------------------
/// ViewModel del selector de instituciones (RF-04).
/// Carga (mock) las instituciones donde el docente está dado de alta.
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../../../core/session/session_service.dart';
import '../model/institucion_model.dart';

enum CargaEstado { idle, cargando, listo, error }

class InstitucionesViewModel extends ChangeNotifier {
  InstitucionesViewModel(this._session);

  final SessionService _session;

  CargaEstado _estado = CargaEstado.idle;
  List<Institucion> _instituciones = [];
  String? _error;

  CargaEstado get estado => _estado;
  List<Institucion> get instituciones => _instituciones;
  String? get error => _error;
  bool get cargando => _estado == CargaEstado.cargando;

  Future<void> cargar() async {
    _estado = CargaEstado.cargando;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _instituciones = InstitucionesDemo.catalogo;
    _estado = CargaEstado.listo;
    notifyListeners();
  }

  void seleccionar(Institucion inst) {
    _session.setInstitucionActiva(inst);
    notifyListeners();
  }

  Future<bool> registrar(Institucion nueva) async {
    if (nueva.nombre.trim().isEmpty) {
      _error = 'El nombre de la institución es obligatorio.';
      notifyListeners();
      return false;
    }
    _estado = CargaEstado.cargando;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _instituciones = [..._instituciones, nueva];
    _estado = CargaEstado.listo;
    notifyListeners();
    return true;
  }
}
