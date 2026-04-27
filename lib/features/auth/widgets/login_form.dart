/// =============================================================================
/// login_form.dart
/// -----------------------------------------------------------------------------
/// Formulario del login. Encapsula campos y botón principal.
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/password_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/standard_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.correoCtrl,
    required this.passwordCtrl,
    required this.onSubmit,
    required this.cargando,
    this.errorText,
  });

  final TextEditingController correoCtrl;
  final TextEditingController passwordCtrl;
  final VoidCallback onSubmit;
  final bool cargando;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StandardTextField(
          controller: correoCtrl,
          label: 'Correo institucional',
          hint: 'usuario@itt.edu.mx',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.alternate_email,
        ),
        AppSpacing.vGapMd,
        PasswordTextField(
          controller: passwordCtrl,
          errorText: errorText,
        ),
        AppSpacing.vGapLg,
        PrimaryButton(
          label: 'Iniciar sesión',
          icon: Icons.login,
          isLoading: cargando,
          onPressed: cargando ? null : onSubmit,
        ),
      ],
    );
  }
}
