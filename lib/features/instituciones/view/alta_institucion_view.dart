/// =============================================================================
/// alta_institucion_view.dart
/// -----------------------------------------------------------------------------
/// RF-04: Alta de nueva institución (con opción de cargar logotipo).
/// =============================================================================
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/standard_text_field.dart';

class AltaInstitucionView extends StatefulWidget {
  const AltaInstitucionView({super.key});

  @override
  State<AltaInstitucionView> createState() => _AltaInstitucionViewState();
}

class _AltaInstitucionViewState extends State<AltaInstitucionView> {
  final TextEditingController _nombre = TextEditingController();
  bool _logoSeleccionado = false;

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva institución')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeader(
                titulo: 'Datos de la institución',
                subtitulo:
                    'El logotipo es opcional. Si no lo cargas, se mostrará '
                    'un ícono genérico (RF-04).',
              ),
              AppSpacing.vGapMd,
              StandardTextField(
                controller: _nombre,
                label: 'Nombre',
                prefixIcon: Icons.apartment,
                textCapitalization: TextCapitalization.words,
              ),
              AppSpacing.vGapLg,
              _LogoUploader(
                logoCargado: _logoSeleccionado,
                onTap: () => setState(
                  () => _logoSeleccionado = !_logoSeleccionado,
                ),
              ),
              AppSpacing.vGapXxl,
              PrimaryButton(
                label: 'Guardar institución',
                icon: Icons.save_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Institución guardada (mock). Conexión real pendiente.',
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoUploader extends StatelessWidget {
  const _LogoUploader({required this.logoCargado, required this.onTap});

  final bool logoCargado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: AppSpacing.paddingCard,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                logoCargado ? Icons.image : Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Text(
                logoCargado
                    ? 'Logo seleccionado (mock)'
                    : 'Cargar logotipo (PNG/JPG · máx. 2 MB)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
