/// @file: generar_clave_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: RF-01: Genera clave de asistencia real desde Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_header.dart';
import '../viewmodel/clave_asistencia_viewmodel.dart';
import '../viewmodel/grupos_viewmodel.dart';

class GenerarClaveView extends StatelessWidget {
  const GenerarClaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GruposViewModel()..cargar()),
        ChangeNotifierProvider(create: (_) => ClaveAsistenciaViewModel()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Clave de asistencia')),
        body: Consumer2<GruposViewModel, ClaveAsistenciaViewModel>(
          builder: (_, gruposVm, claveVm, __) {
            if (gruposVm.cargando) return const LoadingState();

            if (gruposVm.grupos.isEmpty) {
              return const EmptyState(
                titulo: 'Sin grupos',
                descripcion: 'Crea un grupo primero para generar claves.',
                icon: Icons.groups_outlined,
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeader(
                      titulo: 'Selecciona el grupo',
                      subtitulo: 'La clave se genera para la sesión activa.',
                    ),
                    AppSpacing.vGapMd,

                    // Selector de grupo
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Grupo',
                        prefixIcon: Icon(Icons.groups),
                        border: OutlineInputBorder(),
                      ),
                      value: claveVm.classroomId,
                      items: gruposVm.grupos.map((g) {
                        return DropdownMenuItem(
                          value: g.id,
                          child: Text(g.materia),
                        );
                      }).toList(),
                      onChanged: (id) {
                        if (id != null) claveVm.seleccionarGrupo(id);
                      },
                    ),
                    AppSpacing.vGapLg,

                    // Clave activa
                    _ClaveBox(clave: claveVm.clave),
                    AppSpacing.vGapLg,

                    // Toggle sesión
                    if (claveVm.sessionId != null)
                      SwitchListTile.adaptive(
                        title: Text(
                          claveVm.abierta
                              ? 'Ventana ABIERTA — alumnos pueden enviar'
                              : 'Ventana CERRADA',
                        ),
                        activeThumbColor: AppColors.success,
                        value: claveVm.abierta,
                        onChanged: (v) {
                          if (v) {
                            claveVm.generarClave();
                          } else {
                            claveVm.cerrarSesion();
                          }
                        },
                      ),

                    AppSpacing.vGapMd,

                    // Contador de registrados
                    if (claveVm.sessionId != null)
                      InfoCard(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.how_to_reg,
                              color: AppColors.primary,
                            ),
                            AppSpacing.hGapMd,
                            Expanded(
                              child: Text(
                                'Alumnos registrados: ${claveVm.registrados}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ),

                    AppSpacing.vGapXl,

                    // Error
                    if (claveVm.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Text(
                          claveVm.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    PrimaryButton(
                      label: claveVm.abierta
                          ? 'Generar nueva clave'
                          : 'Abrir sesión',
                      icon: Icons.refresh,
                      isLoading: claveVm.cargando,
                      onPressed: claveVm.classroomId == null || claveVm.cargando
                          ? null
                          : claveVm.abierta
                          ? claveVm.generarClave
                          : claveVm.abrirSesion,
                    ),

                    if (claveVm.abierta) ...[
                      AppSpacing.vGapMd,
                      OutlinedButton.icon(
                        onPressed: claveVm.cerrarSesion,
                        icon: const Icon(Icons.lock),
                        label: const Text('Cerrar sesión'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ClaveBox extends StatelessWidget {
  const _ClaveBox({required this.clave});
  final String? clave;

  @override
  Widget build(BuildContext context) {
    final placeholder = clave == null;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            placeholder ? 'Genera una clave' : 'Clave activa',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.85),
            ),
          ),
          AppSpacing.vGapSm,
          Text(
            placeholder ? '— — — — — — — —' : clave!,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.textOnPrimary,
              letterSpacing: 4,
            ),
          ),
          if (!placeholder) ...[
            AppSpacing.vGapSm,
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: clave!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Clave copiada')),
                );
              },
              icon: const Icon(Icons.copy, color: AppColors.textOnPrimary),
              label: const Text(
                'Copiar',
                style: TextStyle(color: AppColors.textOnPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}