/// @file: dashboard_alumno_viewmodel.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: ViewModel del dashboard del alumno. Datos reales desde Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/foundation.dart';
import '../../../services/alumno_service.dart';
import '../model/materia_model.dart';

enum DashboardEstado { idle, cargando, listo, error }

class DashboardAlumnoViewModel extends ChangeNotifier {
  DashboardEstado _estado = DashboardEstado.idle;
  List<Materia> _materias = [];
  String? _error;

  DashboardEstado get estado => _estado;
  List<Materia> get materias => _materias;
  String? get error => _error;
  bool get cargando => _estado == DashboardEstado.cargando;

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
    _error = null;
    notifyListeners();

    final result = await AlumnoService.getMaterias();

    if (result['success'] == true) {
      final List data = result['data'] ?? [];
      _materias = data.map((e) => Materia.fromJson(e)).toList();
      _estado = DashboardEstado.listo;
    } else {
      _error = result['message'];
      _estado = DashboardEstado.error;
    }

    notifyListeners();
  }

  Materia? buscar(String id) {
    for (final m in _materias) {
      if (m.id == id) return m;
    }
    return null;
  }
}