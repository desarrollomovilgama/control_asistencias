/// =============================================================================
/// credenciales_demo.dart
/// -----------------------------------------------------------------------------
/// Catálogo de credenciales DEMO para pruebas locales sin backend.
/// Apartado 7.2 del MPF (Autenticación).
///
/// EN PRODUCCIÓN: este archivo desaparece y la autenticación se hace contra
/// el WS de la institución (o el backend propio en Heroku).
/// =============================================================================
library;

import '../../features/auth/model/usuario_model.dart';

/// Dominios institucionales aceptados en la maqueta.
const List<String> kDominiosInstitucionales = <String>[
  '@gama.mx',
  '@itt.edu.mx',
  '@universidad.mx',
];

bool tieneDominioInstitucional(String correo) {
  final c = correo.toLowerCase();
  return kDominiosInstitucionales.any(c.endsWith);
}

class CredencialDemo {
  const CredencialDemo({
    required this.correo,
    required this.password,
    required this.usuario,
  });

  final String correo;
  final String password;
  final Usuario usuario;
}

final List<CredencialDemo> _catalogo = <CredencialDemo>[
  CredencialDemo(
    correo: 'alumno@itt.edu.mx',
    password: 'demo1234',
    usuario: Usuario(
      id: 'A-001',
      nombreCompleto: 'Ana Pérez Torres',
      correo: 'alumno@itt.edu.mx',
      tipo: TipoUsuario.alumno,
    ),
  ),
  CredencialDemo(
    correo: 'docente@itt.edu.mx',
    password: 'demo1234',
    usuario: Usuario(
      id: 'D-001',
      nombreCompleto: 'Mauro Sánchez Sánchez',
      correo: 'docente@itt.edu.mx',
      tipo: TipoUsuario.docente,
    ),
  ),
  CredencialDemo(
    correo: 'docente@universidad.mx',
    password: 'demo1234',
    usuario: Usuario(
      id: 'D-002',
      nombreCompleto: 'Gamaliel Castro González',
      correo: 'docente@universidad.mx',
      tipo: TipoUsuario.docente,
    ),
  ),
];

CredencialDemo? buscarCredencial({
  required String correo,
  required String password,
}) {
  final c = correo.trim().toLowerCase();
  for (final cred in _catalogo) {
    if (cred.correo == c && cred.password == password) return cred;
  }
  return null;
}
