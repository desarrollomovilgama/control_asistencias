/// @file: instituciones_viewmodel.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: ViewModel del selector de institución del docente.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../core/session/session_service.dart';
import '../../../services/api_client.dart';
import '../model/institucion_model.dart';

enum CargaEstado { idle, cargando, listo, error }

class InstitucionesViewModel extends ChangeNotifier {
  InstitucionesViewModel(this._session);

  final SessionService _session;

  CargaEstado _estado   = CargaEstado.idle;
  Institucion? _institucion;
  String?      _error;

  CargaEstado  get estado      => _estado;
  Institucion? get institucion => _institucion;
  String?      get error       => _error;
  bool         get cargando    => _estado == CargaEstado.cargando;

  // Mantenemos lista para compatibilidad con la vista
  List<Institucion> get instituciones =>
      _institucion != null ? [_institucion!] : [];

  Future<void> cargar() async {
    _estado = CargaEstado.cargando;
    _error  = null;
    notifyListeners();

    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/docente/institucion');

      if (response.data['success'] == true) {
        _institucion = Institucion.fromJson(response.data['data']);
        _session.setInstitucionActiva(_institucion!);
        _estado = CargaEstado.listo;
      } else {
        _error  = response.data['message'] ?? 'Error al cargar institución.';
        _estado = CargaEstado.error;
      }
    } on DioException catch (e) {
      _error  = e.response?.data['message'] ?? 'Sin conexión con el servidor.';
      _estado = CargaEstado.error;
    } catch (e) {
      _error  = 'Error inesperado.';
      _estado = CargaEstado.error;
    }

    notifyListeners();
  }

  void seleccionar(Institucion inst) {
    _session.setInstitucionActiva(inst);
    notifyListeners();
  }
}