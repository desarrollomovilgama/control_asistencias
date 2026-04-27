/// =============================================================================
/// login_footer.dart
/// -----------------------------------------------------------------------------
/// Pie del login con enlace a registro.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        AppSpacing.hGapXs,
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(RouteNames.registro),
          child: const Text('Crear cuenta'),
        ),
      ],
    );
  }
}
