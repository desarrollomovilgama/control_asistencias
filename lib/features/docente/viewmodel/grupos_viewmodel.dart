/// @file: grupos_viewmodel.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: ViewModel para los grupos del docente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/foundation.dart';
import '../../../services/docente_service.dart';
import '../model/grupo_model.dart';

class GruposViewModel extends ChangeNotifier {
  bool    _cargando = false;
  List<Grupo> _grupos = [];
  String? _error;

  bool        get cargando => _cargando;
  List<Grupo> get grupos   => _grupos;
  String?     get error    => _error;

  Future<void> cargar() async {
    _cargando = true;
    _error    = null;
    notifyListeners();

    final result = await DocenteService.getGrupos();

    if (result['success'] == true) {
      final List data = result['data'] ?? [];
      _grupos = data.map((e) => Grupo.fromJson(e)).toList();
    } else {
      _error = result['message'];
    }

    _cargando = false;
    notifyListeners();
  }

  Future<bool> crearGrupo({
    required String subjectName,
    required String period,
    required int    minAttendancePct,
  }) async {
    _cargando = true;
    notifyListeners();

    final result = await DocenteService.crearGrupo(
      subjectName:      subjectName,
      period:           period,
      minAttendancePct: minAttendancePct,
    );

    if (result['success'] == true) {
      await cargar();
      return true;
    }

    _error    = result['message'];
    _cargando = false;
    notifyListeners();
    return false;
  }

  Future<bool> eliminarAlumno({required String enrollmentId}) async {
    final result = await DocenteService.eliminarAlumno(
      enrollmentId: enrollmentId,
    );

    if (result['success'] == true) {
      await cargar();
      return true;
    }

    _error = result['message'];
    notifyListeners();
    return false;
  }

  Grupo? buscar(String id) {
    for (final g in _grupos) {
      if (g.id == id) return g;
    }
    return null;
  }
}