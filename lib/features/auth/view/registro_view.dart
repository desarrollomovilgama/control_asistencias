/// =============================================================================
/// registro_view.dart
/// -----------------------------------------------------------------------------
/// Registro de cuenta nueva. Selecciona el rol (alumno / docente).
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/password_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/standard_text_field.dart';
import '../model/usuario_model.dart';
import '../viewmodel/auth_viewmodel.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key});

  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _password = TextEditingController();
  TipoUsuario _tipo = TipoUsuario.alumno;

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(AuthViewModel vm) async {
    final ok = await vm.registrar(
      nombre: _nombre.text,
      correo: _correo.text,
      password: _password.text,
      tipo: _tipo,
    );
    if (!mounted || !ok) return;
    final ruta = _tipo == TipoUsuario.docente
        ? RouteNames.seleccionInstitucion
        : RouteNames.dashboardAlumno;
    Navigator.of(context).pushReplacementNamed(ruta);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(context.read<SessionService>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Crear cuenta')),
        body: SafeArea(
          child: Consumer<AuthViewModel>(
            builder: (_, vm, __) {
              return SingleChildScrollView(
                padding: AppSpacing.paddingScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StandardTextField(
                      controller: _nombre,
                      label: 'Nombre completo',
                      prefixIcon: Icons.person_outline,
                      textCapitalization: TextCapitalization.words,
                    ),
                    AppSpacing.vGapMd,
                    StandardTextField(
                      controller: _correo,
                      label: 'Correo institucional',
                      prefixIcon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppSpacing.vGapMd,
                    PasswordTextField(controller: _password),
                    AppSpacing.vGapLg,
                    Text(
                      'Rol',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    AppSpacing.vGapSm,
                    SegmentedButton<TipoUsuario>(
                      segments: const [
                        ButtonSegment(
                          value: TipoUsuario.alumno,
                          label: Text('Alumno'),
                          icon: Icon(Icons.school),
                        ),
                        ButtonSegment(
                          value: TipoUsuario.docente,
                          label: Text('Docente'),
                          icon: Icon(Icons.cast_for_education),
                        ),
                      ],
                      selected: {_tipo},
                      onSelectionChanged: (s) =>
                          setState(() => _tipo = s.first),
                    ),
                    AppSpacing.vGapLg,
                    if (vm.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          vm.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    PrimaryButton(
                      label: 'Registrarme',
                      icon: Icons.app_registration,
                      isLoading: vm.cargando,
                      onPressed:
                          vm.cargando ? null : () => _onSubmit(vm),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
