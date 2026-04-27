/// =============================================================================
/// api_service.dart
/// -----------------------------------------------------------------------------
/// Cliente HTTP centralizado (Dio). Apartado 5.2 del MPF.
/// Esqueleto: lee API_BASE_URL desde .env y expone una instancia singleton.
/// La integración real con endpoints se conecta en una iteración posterior.
/// =============================================================================
library;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  ApiService._internal() {
    final base = dotenv.maybeGet('API_BASE_URL') ?? 'https://api.ejemplo.com';
    _dio = Dio(
      BaseOptions(
        baseUrl: base,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  static final ApiService instance = ApiService._internal();

  late final Dio _dio;

  Dio get dio => _dio;
}
