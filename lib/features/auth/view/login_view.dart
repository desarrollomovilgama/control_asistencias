/// @file: login_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: Vista de inicio de sesión.
/// @version: 2.0.0
/// @last_update: 2026-06-01
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/session/session_service.dart';
import '../../../core/spacing/app_spacing.dart';
import '../model/usuario_model.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _correo   = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _correo.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(AuthViewModel vm) async {
    final ok = await vm.iniciarSesion(
      correo:   _correo.text,
      password: _password.text,
    );
    if (!mounted || !ok) return;
    final ruta = vm.usuario?.tipo == TipoUsuario.docente
        ? RouteNames.seleccionInstitucion
        : RouteNames.dashboardAlumno;
    Navigator.of(context).pushReplacementNamed(ruta);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(context.read<SessionService>()),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<AuthViewModel>(
            builder: (_, vm, __) {
              return SingleChildScrollView(
                padding: AppSpacing.paddingScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.vGapXxl,
                    const LoginHeader(),
                    AppSpacing.vGapXxl,
                    LoginForm(
                      correoCtrl:  _correo,
                      passwordCtrl: _password,
                      cargando:    vm.cargando,
                      errorText:   vm.error,
                      onSubmit:    () => _onSubmit(vm),
                    ),
                    AppSpacing.vGapLg,
                    const LoginFooter(),
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