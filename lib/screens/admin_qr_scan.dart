import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/admin_disposal_provider.dart';

class AdminQRScanScreen extends ConsumerStatefulWidget {
  const AdminQRScanScreen({super.key});

  @override
  ConsumerState<AdminQRScanScreen> createState() => _AdminQRScanScreenState();
}

class _AdminQRScanScreenState extends ConsumerState<AdminQRScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false; // avoid double reads

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) await Permission.camera.request();
  }

  /* ─────────────── CORE LOGIC ─────────────── */
  Future<void> _handleScan(String qr) async {
  if (_isProcessing) return;
  _isProcessing = true;
  _controller.stop();

  final supabase = Supabase.instance.client;

  try {
  
    final parts = qr.split('|');
    final idPart = parts.firstWhere((part) => part.startsWith('ID:'),
        orElse: () => '');
    final appointmentId = idPart.replaceFirst('ID:', '').trim();

    if (appointmentId.isEmpty) {
      _showSnack('Invalid QR Code format.', Colors.red);
      return;
    }

    final service = await ref.read(adminServiceProvider.future);
    final serviceId = service.serviceId;

    final rows = await supabase
        .from('appointment_info')
        .select()
        .eq('appointment_info_id', appointmentId)
        .eq('service_id', serviceId)
        .limit(1);

    if (rows.isEmpty) {
      _showSnack('No matching appointment found', Colors.red);
      return;
    }

    final row = rows.first;

    if (row['appointment_status'] == 'Completed') {
      _showSnack(
        'Appointment is already ${row['appointment_status']}.',
        Colors.orange,
      );
      return;
    }

    await supabase
        .from('appointment_info')
        .update({
      'appointment_status': 'Completed',
      'appointment_confirm_date': DateTime.now().toIso8601String(),
    })
        .eq('appointment_info_id', row['appointment_info_id']);

    _showSnack('Appointment confirmed ✔️', Colors.green);

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.pop(context);
  } catch (e) {
    _showSnack('Error confirming appointment: $e', Colors.red);
  } finally {
    _isProcessing = false;
    if (mounted) _controller.start();
  }
}


  void _showSnack(String msg, Color bg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: bg),
    );
  }

  /* ─────────────── UI ─────────────── */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final code = capture.barcodes.first.rawValue;
              if (code != null) _handleScan(code);
            },
          ),

          // Back button
          _pillButton(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            icon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),

          // Torch toggle
          _pillButton(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            builder: (ctx) => ValueListenableBuilder(
              valueListenable: _controller.torchState,
              builder: (_, state, __) => Icon(
                state == TorchState.off ? Icons.flash_off : Icons.flash_on,
                color: Colors.black,
                size: 24,
              ),
            ),
            onTap: _controller.toggleTorch,
          ),
        ],
      ),
    );
  }

  /// Re‑usable pill‑style container
  Widget _pillButton({
    double? top,
    double? left,
    double? right,
    required GestureTapCallback onTap,
    IconData? icon,
    WidgetBuilder? builder,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: builder != null
              ? builder(context)
              : Icon(icon, color: Colors.black, size: 24),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}