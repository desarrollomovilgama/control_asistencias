/// =============================================================================
/// rubros_viewmodel.dart
/// -----------------------------------------------------------------------------
/// RF-05: configuración de rubros y porcentajes por institución/materia.
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../../instituciones/model/institucion_model.dart';

class RubrosViewModel extends ChangeNotifier {
  RubrosViewModel(this.institucionInicial)
      : _rubros = List.of(institucionInicial.rubros);

  final Institucion institucionInicial;
  List<RubroEvaluacion> _rubros;

  List<RubroEvaluacion> get rubros => _rubros;

  void agregar(RubroEvaluacion r) {
    _rubros = [..._rubros, r];
    notifyListeners();
  }

  void actualizar(int idx, double nuevoPorcentaje) {
    if (idx < 0 || idx >= _rubros.length) return;
    final clamp = nuevoPorcentaje.clamp(0.0, 1.0);
    _rubros[idx] = _rubros[idx].copyWith(porcentajeMinimo: clamp);
    notifyListeners();
  }

  void eliminar(int idx) {
    if (idx < 0 || idx >= _rubros.length) return;
    _rubros = [..._rubros]..removeAt(idx);
    notifyListeners();
  }
}
