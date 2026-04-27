/// =============================================================================
/// widget_test.dart
/// -----------------------------------------------------------------------------
/// Smoke test mínimo: verifica que la app arranca y muestra el splash.
/// =============================================================================
library;

import 'package:control_asistencias/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La app arranca y muestra el splash', (tester) async {
    await tester.pumpWidget(const ControlAsistenciasApp());
    expect(find.text('Control de Asistencias'), findsOneWidget);
  });
}
