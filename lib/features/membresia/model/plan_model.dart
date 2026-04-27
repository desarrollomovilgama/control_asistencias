/// =============================================================================
/// plan_model.dart
/// -----------------------------------------------------------------------------
/// Modelos para los planes de membresía (RF-15).
/// =============================================================================
library;

class PlanMembresia {
  const PlanMembresia({
    required this.id,
    required this.nombre,
    required this.precioMensual,
    required this.maxAlumnosPorSalon,
    required this.aulasIlimitadas,
    required this.reportesExcelPdf,
    required this.gestionJustificantes,
    required this.historialDias,
  });

  final String id;
  final String nombre;
  final double precioMensual;
  final int maxAlumnosPorSalon;
  final bool aulasIlimitadas;
  final bool reportesExcelPdf;
  final bool gestionJustificantes;
  final int historialDias; // 0 = ilimitado
}

class PlanesDemo {
  PlanesDemo._();

  static const PlanMembresia basico = PlanMembresia(
    id: 'plan-basico',
    nombre: 'Básico',
    precioMensual: 0,
    maxAlumnosPorSalon: 15,
    aulasIlimitadas: false,
    reportesExcelPdf: false,
    gestionJustificantes: false,
    historialDias: 7,
  );

  static const PlanMembresia mensual = PlanMembresia(
    id: 'plan-mensual',
    nombre: 'Mensual',
    precioMensual: 199,
    maxAlumnosPorSalon: 50,
    aulasIlimitadas: true,
    reportesExcelPdf: true,
    gestionJustificantes: true,
    historialDias: 0,
  );

  static const List<PlanMembresia> catalogo = [basico, mensual];
}
