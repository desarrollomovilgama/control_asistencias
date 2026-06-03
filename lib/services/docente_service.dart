/// @file: docente_service.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Servicio HTTP para todas las operaciones del docente.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:dio/dio.dart';
import 'api_client.dart';

class DocenteService {

  // -------------------------------------------------------------------------
  // GRUPOS
  // -------------------------------------------------------------------------

  /// Obtiene los grupos del docente autenticado
  static Future<Map<String, dynamic>> getGrupos() async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/docente/classrooms');
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Crea un nuevo grupo
  static Future<Map<String, dynamic>> crearGrupo({
    required String subjectName,
    required String period,
    required int    minAttendancePct,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.post(
        '/docente/classrooms',
        data: {
          'subject_name':       subjectName,
          'period':             period,
          'min_attendance_pct': minAttendancePct,
        },
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Genera un código de invitación para un grupo
  static Future<Map<String, dynamic>> generarCodigoGrupo({
    required String classroomId,
    int dias = 7,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.post(
        '/docente/classrooms/$classroomId/code',
        data: {'dias': dias},
      );
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Obtiene los alumnos de un grupo
  static Future<Map<String, dynamic>> getAlumnos({
    required String classroomId,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get(
        '/docente/classrooms/$classroomId/students',
      );
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Elimina un alumno del grupo
  static Future<Map<String, dynamic>> eliminarAlumno({
    required String enrollmentId,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.delete(
        '/docente/enrollments/$enrollmentId',
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  // -------------------------------------------------------------------------
  // SESIONES Y CLAVES
  // -------------------------------------------------------------------------

  /// Abre una sesión de clase
  static Future<Map<String, dynamic>> abrirSesion({
    required String classroomId,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.post(
        '/docente/sessions',
        data: {'classroom_id': classroomId},
      );
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Genera una clave de asistencia para una sesión
  static Future<Map<String, dynamic>> generarClave({
    required String sessionId,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.post(
        '/docente/sessions/$sessionId/key',
      );
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Cierra una sesión de clase
  static Future<Map<String, dynamic>> cerrarSesion({
    required String sessionId,
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.patch(
        '/docente/sessions/$sessionId/close',
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  // -------------------------------------------------------------------------
  // JUSTIFICANTES
  // -------------------------------------------------------------------------

  /// Obtiene los justificantes pendientes del docente
  static Future<Map<String, dynamic>> getJustificantes() async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/docente/justifications');
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }

  /// Resuelve un justificante (aprobar o rechazar)
  static Future<Map<String, dynamic>> resolverJustificante({
    required String justificationId,
    required String status, // 'approved' o 'rejected'
  }) async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.patch(
        '/docente/justifications/$justificationId',
        data: {'status': status},
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
  /// Obtiene la membresía activa de la institución del docente
  static Future<Map<String, dynamic>> getMembresia() async {
    try {
      await ApiClient.setAuthToken();
      final response = await ApiClient.dio.get('/docente/membresia');
      return {'success': true, 'data': response.data['data']};
    } on DioException catch (e) {
      return {'success': false, 'message': _parsearError(e)};
    } catch (e) {
      return {'success': false, 'message': 'Error inesperado.'};
    }
  }
}