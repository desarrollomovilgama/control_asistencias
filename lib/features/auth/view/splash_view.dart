/// @file: splash_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Pantalla inicial con verificación de sesión persistida.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/auth/model/usuario_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _verificarSesion());
  }

  Future<void> _verificarSesion() async {
    final session = context.read<SessionService>();
    final haySession = await session.cargarSesion();

    if (!mounted) return;

    if (haySession) {
      final ruta = session.esDocente
          ? RouteNames.seleccionInstitucion
          : RouteNames.dashboardAlumno;
      Navigator.of(context).pushReplacementNamed(ruta);
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.fact_check,
              size: 96,
              color: AppColors.textOnPrimary,
            ),
            AppSpacing.vGapLg,
            Text(
              'Control de Asistencias',
              style: t.headlineMedium?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            AppSpacing.vGapSm,
            Text(
              'Suite GAMA · Proyecto B',
              style: t.bodyMedium?.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.85),
              ),
            ),
            AppSpacing.vGapXxl,
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: AppColors.textOnPrimary,
                strokeWidth: 2.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}