import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';
import '../widgets/dialogs/successful_scan_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/points_provider.dart';

class QrCodeScreen extends ConsumerStatefulWidget {
  final Appointment appointment;

  const QrCodeScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  ConsumerState<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends ConsumerState<QrCodeScreen> {
  late Timer _pollingTimer;
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final appointment = await AppointmentRepository(
          Supabase.instance.client,
        ).getAppointment(widget.appointment.appointmentInfoId!);

        if (appointment.appointmentStatus == AppointmentStatus.completed &&
            !_hasShownDialog) {
          _hasShownDialog = true;
          _pollingTimer.cancel();

          // Update points first
          final pointsViewModel = ref.read(pointsViewModelProvider);
          await pointsViewModel.addPointsForAppointment(
            widget.appointment.appointmentInfoId!,
            widget.appointment.qrCodeData,
          );

          if (mounted) {
            // Show the success dialog with updated points
            showDialog(
              context: context,
              barrierDismissible: false, // User must tap button to proceed
              builder: (_) => SuccessfulScanDialog(
                appointmentId: widget.appointment.appointmentInfoId!,
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('Error polling appointment status: $e');
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qrData = widget.appointment.qrCodeData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'QR Code',
          style: TextStyle(
            fontFamily: 'Mallanna',
            color: Color(0xFF4B5320),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4B5320)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Scan this QR code',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B5320),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (qrData != null)
                        QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 250,
                          backgroundColor: Colors.white,
                        )
                      else
                        const Icon(
                          Icons.qr_code,
                          size: 250,
                          color: Colors.grey,
                        ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'QR Code Data',
                              style: TextStyle(
                                fontFamily: 'Mallanna',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B5320),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              qrData ?? 'No QR code data available',
                              style: const TextStyle(
                                fontFamily: 'Mallanna',
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Points will be added to your account\nonce the appointment is completed',
                style: TextStyle(
                  fontFamily: 'Mallanna',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
