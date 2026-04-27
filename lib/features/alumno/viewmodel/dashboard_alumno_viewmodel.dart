/// =============================================================================
/// dashboard_alumno_viewmodel.dart
/// -----------------------------------------------------------------------------
/// ViewModel del dashboard del alumno (RF-03).
/// Carga (mock) la lista de materias y expone el porcentaje calculado.
/// =============================================================================
library;

import 'package:flutter/foundation.dart';

import '../model/materia_model.dart';

enum DashboardEstado { idle, cargando, listo, error }

class DashboardAlumnoViewModel extends ChangeNotifier {
  DashboardEstado _estado = DashboardEstado.idle;
  List<Materia> _materias = [];

  DashboardEstado get estado => _estado;
  List<Materia> get materias => _materias;
  bool get cargando => _estado == DashboardEstado.cargando;

  /// % global ponderado (suma de asistencias y justificantes / total).
  double get porcentajeGlobal {
    if (_materias.isEmpty) return 0;
    final tot = _materias.fold<int>(0, (a, m) => a + m.totalSesiones);
    if (tot == 0) return 0;
    final ok = _materias.fold<int>(
      0,
      (a, m) => a + m.asistencias + m.justificadas,
    );
    return ok / tot;
  }

  Future<void> cargar() async {
    _estado = DashboardEstado.cargando;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _materias = MateriasDemo.catalogo();
    _estado = DashboardEstado.listo;
    notifyListeners();
  }

  Materia? buscar(String id) {
    for (final m in _materias) {
      if (m.id == id) return m;
    }
    return null;
  }
}
