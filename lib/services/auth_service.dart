/// @file: auth_service.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Servicio de autenticación contra la API REST de Laravel.
/// @version: 1.2.0
/// @last_update: 2026-06-01
library;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // -------------------------------------------------------------------------
  // REGISTER
  // -------------------------------------------------------------------------

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? institutionCode,  // Obligatorio si role == docente
    String? invitationCode,   // Opcional si role == alumno
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name':     name,
        'email':    email,
        'password': password,
        'role':     role,
      };

      if (institutionCode != null && institutionCode.isNotEmpty) {
        data['institution_code'] = institutionCode.toUpperCase().trim();
      }
      if (invitationCode != null && invitationCode.isNotEmpty) {
        data['invitation_code'] = invitationCode.toUpperCase().trim();
      }

      final response = await ApiClient.dio.post('/register', data: data);

      final token = response.data['token'];
      await _storage.write(key: 'sanctum_token', value: token);
      await ApiClient.setAuthToken();

      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  // -------------------------------------------------------------------------
  // LOGIN
  // -------------------------------------------------------------------------

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      await _storage.write(key: 'sanctum_token', value: token);
      await ApiClient.setAuthToken();

      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  // -------------------------------------------------------------------------
  // LOGOUT
  // -------------------------------------------------------------------------

  static Future<void> logout() async {
    try {
      await ApiClient.dio.post('/logout');
    } catch (_) {}
    await _storage.delete(key: 'sanctum_token');
    ApiClient.clearAuthToken();
  }

  // -------------------------------------------------------------------------
  // UTILIDADES DE SESIÓN
  // -------------------------------------------------------------------------

  static Future<String?> getToken() async =>
      await _storage.read(key: 'sanctum_token');

  static Future<bool> isLoggedIn() async =>
      (await getToken()) != null;

  // -------------------------------------------------------------------------
  // MANEJO DE ERRORES
  // -------------------------------------------------------------------------

  static String _parsearError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;

      if (e.response!.statusCode == 422) {
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map;
          final primer = errors.values.first;
          if (primer is List && primer.isNotEmpty) {
            return primer.first.toString();
          }
        }
        return data['message'] ?? 'Error de validación.';
      }

      if (e.response!.statusCode == 401) return 'Credenciales incorrectas.';
      if (e.response!.statusCode == 404) return data['message'] ?? 'No encontrado.';

      if (e.response!.statusCode == 500) {
        final msg = data['message']?.toString() ?? '';
        if (msg.contains('users_email_unique') || msg.contains('duplicate key')) {
          return 'Este correo ya está registrado.';
        }
        return 'Error interno del servidor.';
      }

      return data['message'] ?? 'Error (${e.response!.statusCode}).';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Tiempo de conexión agotado.';
    }

    return 'Sin conexión con el servidor.';
  }
}