/// =============================================================================
/// splash_view.dart
/// -----------------------------------------------------------------------------
/// Pantalla inicial. Espera 1.5 s y redirige al login.
/// Apartado 4.2 del MPF (Splash).
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _ir();
  }

  Future<void> _ir() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(RouteNames.login);
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
