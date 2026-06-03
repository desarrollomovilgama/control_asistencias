import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: dotenv.env['LARAVEL_BASE_URL']!,
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json','ngrok-skip-browser-warning': 'true'},
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  static const _storage = FlutterSecureStorage();

  // Agregar token Sanctum a cada request
  static Future<void> setAuthToken() async {
    final token = await _storage.read(key: 'sanctum_token');
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Ejemplo: Login contra Laravel
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('/login', data: {
      'email': email,
      'password': password,
    });
    final token = response.data['token'];
    await _storage.write(key: 'sanctum_token', value: token);
    return response.data;
  }

  /// Elimina el token del header (para logout).
  static void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  /// Getter del cliente Dio listo para usar en repositorios.
  static Dio get client => dio;
}
