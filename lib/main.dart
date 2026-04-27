/// =============================================================================
/// main.dart
/// -----------------------------------------------------------------------------
/// Punto de entrada de la app Control de Asistencias (Proyecto B – Móvil GAMA).
/// Apartado 4.2 (Figura 14) y 7.1 del Manual de Programación Flutter (MPF).
///
/// Responsabilidades:
///   - Cargar variables de entorno (.env) antes de runApp.
///   - Inicializar Hive (persistencia local).
///   - Registrar SessionService global (Provider raíz).
///   - Configurar tema, localizaciones y rutas nombradas.
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/route_names.dart';
import 'core/session/session_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga del .env. En modo demo no es obligatorio.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // El archivo .env aún no existe; ver .env.example para las claves.
  }

  // Inicialización de Hive (apartado 6 del MPF).
  await Hive.initFlutter();

  runApp(const ControlAsistenciasApp());
}

class ControlAsistenciasApp extends StatelessWidget {
  const ControlAsistenciasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Sesión global accesible desde cualquier vista (apartado 4.3 del MPF).
        ChangeNotifierProvider<SessionService>(
          create: (_) => SessionService(),
        ),
      ],
      child: MaterialApp(
        title: 'Control de Asistencias',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // Localizaciones (apartado 4.2 del MPF).
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
          Locale('en'),
        ],
        locale: const Locale('es'),
        // Navegación por rutas nombradas (Figura 46 del MPF).
        initialRoute: RouteNames.splash,
        onGenerateRoute: AppRoutes.generate,
      ),
    );
  }
}
