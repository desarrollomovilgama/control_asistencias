/// @file: lista_alumnos_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: RF-08: Lista de alumnos del grupo. Datos reales desde Laravel.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/section_header.dart';
import '../../../services/docente_service.dart';
import '../model/grupo_model.dart';

class ListaAlumnosView extends StatefulWidget {
  const ListaAlumnosView({super.key, required this.classroomId});

  final String classroomId;

  @override
  State<ListaAlumnosView> createState() => _ListaAlumnosViewState();
}

class _ListaAlumnosViewState extends State<ListaAlumnosView> {
  List<AlumnoGrupo> _alumnos = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final result = await DocenteService.getAlumnos(
      classroomId: widget.classroomId,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      final List data = result['data'] ?? [];
      setState(() {
        _alumnos = data.map((e) => AlumnoGrupo.fromJson(e)).toList();
        _cargando = false;
      });
    } else {
      setState(() {
        _error = result['message'];
        _cargando = false;
      });
    }
  }

  Future<void> _darDeBaja(AlumnoGrupo alumno, String enrollmentId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Dar de baja'),
        content: Text(
          '¿Seguro que quieres dar de baja a ${alumno.nombre} del grupo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Dar de baja',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final result = await DocenteService.eliminarAlumno(
      enrollmentId: enrollmentId,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${alumno.nombre} dado de baja del grupo.'),
          backgroundColor: AppColors.success,
        ),
      );
      await _cargar();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Error al dar de baja.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alumnos del grupo')),
      body: _cargando
          ? const LoadingState()
          : _error != null
          ? EmptyState(
        titulo: 'Error al cargar',
        descripcion: _error,
        icon: Icons.error_outline,
        actionLabel: 'Reintentar',
        onAction: _cargar,
      )
          : _alumnos.isEmpty
          ? const EmptyState(
        titulo: 'Sin alumnos',
        descripcion:
        'Aún no hay alumnos inscritos en este grupo.',
        icon: Icons.groups_outlined,
      )
          : RefreshIndicator(
        onRefresh: _cargar,
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.paddingScreen,
              child: SectionHeader(
                titulo: 'Alumnos inscritos',
                subtitulo:
                '${_alumnos.length} alumno(s) en este grupo',
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.paddingScreenHorizontal,
                itemCount: _alumnos.length,
                separatorBuilder: (_, __) => AppSpacing.vGapSm,
                itemBuilder: (_, i) {
                  final a = _alumnos[i];
                  return InfoCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary
                              .withValues(alpha: 0.10),
                          child: Text(
                            a.nombre.isNotEmpty
                                ? a.nombre.substring(0, 1)
                                : '?',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        AppSpacing.hGapMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.nombre,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall,
                              ),
                              Text(
                                '${a.matricula} · ${(a.porcentaje * 100).toStringAsFixed(0)}% asist.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.person_remove,
                            color: AppColors.error,
                          ),
                          tooltip: 'Dar de baja',
                          onPressed: () => _darDeBaja(a, a.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            AppSpacing.vGapLg,
          ],
        ),
      ),
    );
  }
}