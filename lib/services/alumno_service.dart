/// @file: alumno_service.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Servicio HTTP para todas las operaciones del alumno.
/// @author: [Tu nombre]
/// @version: 1.0.0
/// @last_update: 2026-05-29

import 'package:dio/dio.dart';
import 'api_client.dart';

class AlumnoService {

  // -------------------------------------------------------------------------
  // MATERIAS
  // -------------------------------------------------------------------------

  /// Obtiene las materias del alumno autenticado
  static Future<Map<String, dynamic>> getMaterias() async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/classrooms');
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  // -------------------------------------------------------------------------
  // MATRICULACIÓN
  // -------------------------------------------------------------------------

  /// Alumno se matricula con código de invitación
  static Future<Map<String, dynamic>> matricularse({
    required String invitationCode,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.post(
        '/enrollments',
        data: {'invitation_code': invitationCode},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  // -------------------------------------------------------------------------
  // ASISTENCIAS
  // -------------------------------------------------------------------------

  /// Alumno registra asistencia con clave de sesión
  static Future<Map<String, dynamic>> registrarAsistencia({
    required String accessKey,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.post(
        '/attendances',
        data: {'access_key': accessKey},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Obtiene el historial de asistencias del alumno
  static Future<Map<String, dynamic>> getHistorial() async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/attendances/historial');
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Obtiene el progreso de asistencia por materia
  static Future<Map<String, dynamic>> getProgreso() async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/attendances/progreso');
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  // -------------------------------------------------------------------------
  // JUSTIFICANTES
  // -------------------------------------------------------------------------

  /// Alumno solicita justificante para una falta
  static Future<Map<String, dynamic>> solicitarJustificante({
    required String attendanceId,
    required String reason,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.post(
        '/justifications',
        data: {
          'attendance_id': attendanceId,
          'reason': reason,
        },
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

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

      if (e.response!.statusCode == 401) {
        return 'Sesión expirada. Inicia sesión de nuevo.';
      }

      if (e.response!.statusCode == 403) {
        return 'No tienes permiso para realizar esta acción.';
      }

      if (e.response!.statusCode == 404) {
        return data['message'] ?? 'No encontrado.';
      }

      if (e.response!.statusCode == 409) {
        return data['message'] ?? 'Registro duplicado.';
      }

      return data['message'] ?? 'Error del servidor.';
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Tiempo de conexión agotado. Verifica tu red.';
    }

    return 'Sin conexión con el servidor.';
  }
}