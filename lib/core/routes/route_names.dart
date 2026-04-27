/// =============================================================================
/// route_names.dart
/// -----------------------------------------------------------------------------
/// Constantes con los nombres de todas las rutas.
/// =============================================================================
library;

class RouteNames {
  RouteNames._();

  // -------------------- Splash & Autenticación --------------------
  static const String splash = '/';
  static const String login = '/login';
  static const String registro = '/registro';

  // -------------------- Selección de espacio --------------------
  static const String seleccionInstitucion = '/instituciones';
  static const String altaInstitucion = '/instituciones/alta';
  static const String demoTec = '/instituciones/demo/tec';
  static const String demoUniversidad = '/instituciones/demo/universidad';
  static const String comparativaInstituciones = '/instituciones/comparativa';

  // -------------------- Alumno --------------------
  static const String dashboardAlumno = '/alumno/dashboard';
  static const String registroAsistencia = '/alumno/asistencia';
  static const String detalleMateria = '/alumno/materia';
  static const String historialAsistencias = '/alumno/historial';
  static const String matricularseCodigo = '/alumno/matricularse/codigo';
  static const String escanearQr = '/alumno/matricularse/qr';
  static const String solicitarJustificante = '/alumno/justificante';

  // -------------------- Docente --------------------
  static const String homeDocente = '/docente/home';
  static const String perfilDocente = '/docente/perfil';
  static const String gruposDocente = '/docente/grupos';
  static const String crearGrupo = '/docente/grupos/nuevo';
  static const String generarClave = '/docente/clave';
  static const String generarCodigoGrupo = '/docente/grupo/codigo';
  static const String generarQrTemporal = '/docente/grupo/qr';
  static const String listaAlumnos = '/docente/grupo/alumnos';
  static const String detalleAlumnoAsistencia = '/docente/grupo/alumno/asistencia';
  static const String configurarRubros = '/docente/rubros';
  static const String validarJustificantes = '/docente/justificantes';
  static const String reportes = '/docente/reportes';

  // -------------------- Notificaciones --------------------
  static const String notificaciones = '/notificaciones';

  // -------------------- Membresía / pagos --------------------
  static const String planes = '/membresia/planes';
  static const String renovarMembresia = '/membresia/renovar';
  static const String pagoPaypal = '/membresia/pago';

  // -------------------- Errores / utilidades --------------------
  static const String sinConexion = '/errores/sin-conexion';
}
