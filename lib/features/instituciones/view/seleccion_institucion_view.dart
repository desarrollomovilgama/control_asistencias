/// @file: seleccion_institucion_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Carga la institución del docente y navega automáticamente.
/// @version: 2.1.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/error_state.dart';
import '../viewmodel/instituciones_viewmodel.dart';

class SeleccionInstitucionView extends StatelessWidget {
  const SeleccionInstitucionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InstitucionesViewModel(context.read<SessionService>()),
      child: const _SeleccionInstitucionBody(),
    );
  }
}

class _SeleccionInstitucionBody extends StatefulWidget {
  const _SeleccionInstitucionBody();

  @override
  State<_SeleccionInstitucionBody> createState() =>
      _SeleccionInstitucionBodyState();
}

class _SeleccionInstitucionBodyState
    extends State<_SeleccionInstitucionBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  Future<void> _cargar() async {
    final vm = context.read<InstitucionesViewModel>();
    await vm.cargar();
    if (!mounted) return;
    if (vm.institucion != null) {
      Navigator.of(context).pushReplacementNamed(RouteNames.homeDocente);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargando…'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<SessionService>().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNames.login,
                    (_) => false,
              );
            },
          ),
        ],
      ),
      body: Consumer<InstitucionesViewModel>(
        builder: (_, vm, __) {
          if (vm.error != null) {
            return ErrorState(
              mensaje: vm.error!,
              onRetry: _cargar,
            );
          }
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text('Cargando tu institución…'),
              ],
            ),
          );
        },
      ),
    );
  }
}