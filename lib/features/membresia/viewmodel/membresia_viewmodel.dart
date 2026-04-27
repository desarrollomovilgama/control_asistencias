/// =============================================================================
/// membresia_viewmodel.dart
/// -----------------------------------------------------------------------------
/// Estado de la membresía del docente (RF-15).
/// Calcula si el periodo de gracia de 72 h sigue vigente.
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../model/plan_model.dart';

class MembresiaViewModel extends ChangeNotifier {
  PlanMembresia _plan = PlanesDemo.mensual;
  DateTime _vencimiento = DateTime.now().add(const Duration(days: 12));

  PlanMembresia get plan => _plan;
  DateTime get vencimiento => _vencimiento;

  bool get vigente => DateTime.now().isBefore(_vencimiento);

  /// 72 h de gracia tras la fecha de vencimiento.
  bool get enPeriodoDeGracia {
    final ahora = DateTime.now();
    if (ahora.isBefore(_vencimiento)) return false;
    final fin = _vencimiento.add(const Duration(hours: 72));
    return ahora.isBefore(fin);
  }

  bool get bloqueado => !vigente && !enPeriodoDeGracia;

  void cambiarPlan(PlanMembresia nuevo) {
    _plan = nuevo;
    notifyListeners();
  }

  void simularRenovacion() {
    _vencimiento = DateTime.now().add(const Duration(days: 30));
    notifyListeners();
  }

  void simularBloqueo() {
    _vencimiento = DateTime.now().subtract(const Duration(days: 5));
    notifyListeners();
  }
}
