/// =============================================================================
/// app_routes.dart
/// -----------------------------------------------------------------------------
/// Generador de rutas centralizado (onGenerateRoute). Apartado 4.2 del MPF.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../features/alumno/view/dashboard_alumno_view.dart';
import '../../features/alumno/view/detalle_materia_view.dart';
import '../../features/alumno/view/escanear_qr_view.dart';
import '../../features/alumno/view/historial_asistencias_view.dart';
import '../../features/alumno/view/matricularse_codigo_view.dart';
import '../../features/alumno/view/registro_asistencia_view.dart';
import '../../features/alumno/view/solicitar_justificante_view.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/registro_view.dart';
import '../../features/auth/view/splash_view.dart';
import '../../features/docente/model/grupo_model.dart';
import '../../features/docente/view/configurar_rubros_view.dart';
import '../../features/docente/view/crear_grupo_view.dart';
import '../../features/docente/view/detalle_alumno_asistencia_view.dart';
import '../../features/docente/view/generar_clave_view.dart';
import '../../features/docente/view/generar_codigo_grupo_view.dart';
import '../../features/docente/view/generar_qr_temporal_view.dart';
import '../../features/docente/view/grupos_docente_view.dart';
import '../../features/docente/view/home_docente_view.dart';
import '../../features/docente/view/perfil_docente_view.dart';
import '../../features/docente/view/lista_alumnos_view.dart';
import '../../features/docente/view/reportes_view.dart';
import '../../features/docente/view/validar_justificantes_view.dart';
import '../../features/errores/view/sin_conexion_view.dart';
import '../../features/instituciones/view/alta_institucion_view.dart';
import '../../features/instituciones/view/comparativa_instituciones_view.dart';
import '../../features/instituciones/view/demo_tec_view.dart';
import '../../features/instituciones/view/demo_universidad_view.dart';
import '../../features/instituciones/view/seleccion_institucion_view.dart';
import '../../features/membresia/view/pago_paypal_view.dart';
import '../../features/membresia/view/planes_view.dart';
import '../../features/membresia/view/renovar_membresia_view.dart';
import '../../features/notificaciones/view/notificaciones_view.dart';
import 'route_names.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      // -------------------- Splash & Auth --------------------
      case RouteNames.splash:
        return _build(const SplashView(), settings);
      case RouteNames.login:
        return _build(const LoginView(), settings);
      case RouteNames.registro:
        return _build(const RegistroView(), settings);

      // -------------------- Instituciones --------------------
      case RouteNames.seleccionInstitucion:
        return _build(const SeleccionInstitucionView(), settings);
      case RouteNames.altaInstitucion:
        return _build(const AltaInstitucionView(), settings);
      case RouteNames.demoTec:
        return _build(const DemoTecView(), settings);
      case RouteNames.demoUniversidad:
        return _build(const DemoUniversidadView(), settings);
      case RouteNames.comparativaInstituciones:
        return _build(const ComparativaInstitucionesView(), settings);

      // -------------------- Alumno --------------------
      case RouteNames.dashboardAlumno:
        return _build(const DashboardAlumnoView(), settings);
      case RouteNames.registroAsistencia:
        return _build(const RegistroAsistenciaView(), settings);
      case RouteNames.detalleMateria:
        final args = settings.arguments as Map<String, dynamic>?;
        return _build(
          DetalleMateriaView(materiaId: args?['materiaId'] as String? ?? '---'),
          settings,
        );
      case RouteNames.historialAsistencias:
        return _build(const HistorialAsistenciasView(), settings);
      case RouteNames.matricularseCodigo:
        return _build(const MatricularseCodigoView(), settings);
      case RouteNames.escanearQr:
        return _build(const EscanearQrView(), settings);
      case RouteNames.solicitarJustificante:
        final args = settings.arguments as Map<String, dynamic>?;
        return _build(
          SolicitarJustificanteView(
            faltaId: args?['faltaId'] as String? ?? '---',
          ),
          settings,
        );

      // -------------------- Docente --------------------
      case RouteNames.homeDocente:
        return _build(const HomeDocenteView(), settings);
      case RouteNames.perfilDocente:
        return _build(const PerfilDocenteView(), settings);
      case RouteNames.gruposDocente:
        return _build(const GruposDocenteView(), settings);
      case RouteNames.crearGrupo:
        return _build(const CrearGrupoView(), settings);
      case RouteNames.generarClave:
        return _build(const GenerarClaveView(), settings);
      case RouteNames.generarCodigoGrupo:
        return _build(const GenerarCodigoGrupoView(), settings);
      case RouteNames.generarQrTemporal:
        return _build(const GenerarQrTemporalView(), settings);
      case RouteNames.listaAlumnos:
        return _build(const ListaAlumnosView(), settings);
      case RouteNames.detalleAlumnoAsistencia:
        final alumno = settings.arguments as AlumnoGrupo;
        return _build(DetalleAlumnoAsistenciaView(alumno: alumno), settings);
      case RouteNames.configurarRubros:
        return _build(const ConfigurarRubrosView(), settings);
      case RouteNames.validarJustificantes:
        return _build(const ValidarJustificantesView(), settings);
      case RouteNames.reportes:
        return _build(const ReportesView(), settings);

      // -------------------- Notificaciones --------------------
      case RouteNames.notificaciones:
        return _build(const NotificacionesView(), settings);

      // -------------------- Membresía --------------------
      case RouteNames.planes:
        return _build(const PlanesView(), settings);
      case RouteNames.renovarMembresia:
        return _build(const RenovarMembresiaView(), settings);
      case RouteNames.pagoPaypal:
        return _build(const PagoPaypalView(), settings);

      // -------------------- Errores --------------------
      case RouteNames.sinConexion:
        return _build(const SinConexionView(), settings);

      default:
        return _build(const _RutaNoEncontrada(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _build(Widget child, RouteSettings s) {
    return MaterialPageRoute(builder: (_) => child, settings: s);
  }
}

class _RutaNoEncontrada extends StatelessWidget {
  const _RutaNoEncontrada();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Ruta no encontrada')),
    );
  }
}
