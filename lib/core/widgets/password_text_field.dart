/// =============================================================================
/// password_text_field.dart
/// -----------------------------------------------------------------------------
/// Campo de contraseña con toggle de visibilidad. Apartado 4.2 del MPF.
/// =============================================================================
library;

import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    this.label = 'Contraseña',
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _oculto,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_oculto ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _oculto = !_oculto),
        ),
        errorText: widget.errorText,
      ),
    );
  }
}
