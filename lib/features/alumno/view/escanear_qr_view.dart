/// @file: escanear_qr_view.dart
/// @project: Proyecto B - GAMA Solutions
/// @description: RF-07: Escaneo de QR para matriculación. Cámara real.
/// @version: 1.0.0
/// @last_update: 2026-05-29
library;

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/spacing/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/alumno_service.dart';

class EscanearQrView extends StatefulWidget {
  const EscanearQrView({super.key});

  @override
  State<EscanearQrView> createState() => _EscanearQrViewState();
}

class _EscanearQrViewState extends State<EscanearQrView> {
  final MobileScannerController _controller = MobileScannerController();
  bool _procesando = false;
  bool _escaneado = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    // Evitar procesar múltiples lecturas
    if (_procesando || _escaneado) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final codigo = barcode.rawValue!;

    setState(() {
      _procesando = true;
      _escaneado = true;
    });

    // Pausar el escáner mientras procesamos
    await _controller.stop();

    final result = await AlumnoService.matricularse(
      invitationCode: codigo,
    );

    if (!mounted) return;

    setState(() => _procesando = false);

    if (result['success'] == true) {
      final materia = result['data']['data']['materia'] ?? 'el grupo';
      _mostrarResultado(
        exito: true,
        mensaje: '¡Te uniste a $materia correctamente!',
      );
    } else {
      _mostrarResultado(
        exito: false,
        mensaje: result['message'] ?? 'Código inválido.',
      );
    }
  }

  void _mostrarResultado({
    required bool exito,
    required String mensaje,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: Icon(
          exito ? Icons.check_circle : Icons.error_outline,
          color: exito ? AppColors.success : AppColors.error,
          size: 48,
        ),
        title: Text(exito ? '¡Éxito!' : 'Error'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el dialog
              if (exito) {
                Navigator.of(context).pop(); // Regresa al dashboard
              } else {
                // Permite escanear de nuevo
                setState(() {
                  _escaneado = false;
                  _procesando = false;
                });
                _controller.start();
              }
            },
            child: Text(exito ? 'Aceptar' : 'Intentar de nuevo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR del grupo'),
        actions: [
          // Toggle linterna
          IconButton(
            icon: const Icon(Icons.flashlight_on),
            tooltip: 'Linterna',
            onPressed: () => _controller.toggleTorch(),
          ),
          // Toggle cámara frontal/trasera
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            tooltip: 'Cambiar cámara',
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Vista de la cámara
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay con marco de escaneo
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          // Indicador de carga mientras procesa
          if (_procesando)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // Instrucción en la parte inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: AppSpacing.paddingScreen,
              color: Colors.black.withValues(alpha: 0.6),
              child: const Text(
                'Apunta la cámara al código QR del docente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}