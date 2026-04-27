/// =============================================================================
/// usuario_model.dart
/// -----------------------------------------------------------------------------
/// Modelo de usuario autenticado del Proyecto B.
/// Solo dos roles activos en la maqueta: alumno y docente.
/// =============================================================================
library;

enum TipoUsuario { alumno, docente, desconocido }

class Usuario {
  const Usuario({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.tipo,
    this.telefono,
    this.urlAvatar,
  });

  final String id;
  final String nombreCompleto;
  final String correo;
  final TipoUsuario tipo;
  final String? telefono;
  final String? urlAvatar;

  bool get esAlumno => tipo == TipoUsuario.alumno;
  bool get esDocente => tipo == TipoUsuario.docente;

  String get inicial =>
      nombreCompleto.isNotEmpty ? nombreCompleto[0].toUpperCase() : '?';

  Usuario copyWith({
    String? id,
    String? nombreCompleto,
    String? correo,
    TipoUsuario? tipo,
    String? telefono,
    String? urlAvatar,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      correo: correo ?? this.correo,
      tipo: tipo ?? this.tipo,
      telefono: telefono ?? this.telefono,
      urlAvatar: urlAvatar ?? this.urlAvatar,
    );
  }
}
