/// @file: notificaciones_viewmodel.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: ViewModel del centro de notificaciones.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../services/api_client.dart';
import '../model/notificacion_model.dart';

class NotificacionesViewModel extends ChangeNotifier {
  bool _cargando = false;
  List<Notificacion> _items = [];
  String? _error;

  bool get cargando => _cargando;
  List<Notificacion> get items => _items;
  String? get error => _error;
  int get noLeidas => _items.where((n) => !n.leida).length;

  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/notificaciones');

      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        _items = data.map((e) => Notificacion.fromJson(e)).toList();
      } else {
        _items = [];
      }
    } on DioException catch (_) {
      _items = [];
    } catch (_) {
      _items = [];
    }

    _cargando = false;
    notifyListeners();
  }
}