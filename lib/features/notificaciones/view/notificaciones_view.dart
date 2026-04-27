/// =============================================================================
/// notificaciones_view.dart
/// -----------------------------------------------------------------------------
/// Centro de notificaciones del usuario (RF-10 / RF-11 / RF-12).
/// =============================================================================
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../viewmodel/notificaciones_viewmodel.dart';
import '../widgets/notificacion_tile.dart';

class NotificacionesView extends StatelessWidget {
  const NotificacionesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificacionesViewModel()..cargar(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notificaciones')),
        body: Consumer<NotificacionesViewModel>(
          builder: (_, vm, __) {
            if (vm.cargando) return const LoadingState();
            if (vm.items.isEmpty) {
              return const EmptyState(
                titulo: 'Sin notificaciones',
                icon: Icons.notifications_off_outlined,
              );
            }
            return ListView.separated(
              padding: AppSpacing.paddingScreen,
              itemCount: vm.items.length,
              separatorBuilder: (_, __) => AppSpacing.vGapSm,
              itemBuilder: (_, i) => NotificacionTile(n: vm.items[i]),
            );
          },
        ),
      ),
    );
  }
}
