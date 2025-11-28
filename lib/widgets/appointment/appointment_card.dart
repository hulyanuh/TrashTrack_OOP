import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/appointment_model.dart';
import '../../models/appointment_waste.dart';
import '../../screens/appointment_details_page.dart';
import '../../providers/disposal_service_provider.dart';

class AppointmentCard extends ConsumerWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPickup = appointment.appointmentType == AppointmentType.pickUp;

    final Map<String, String> appointmentMap = {
      "appointment_info_id": appointment.appointmentInfoId ?? "N/A",
      "appointment_date": _formatDateTime(appointment.appointmentDate),
      "appointment_location": appointment.appointmentLocation,
      "appointment_type": isPickup ? "Pick-Up" : "Drop-Off",
      "appointment_status": _formatStatus(appointment.appointmentStatus),
      "appointment_waste": _formatWasteDetails(appointment.wasteMaterials),
      "appointment_notes": appointment.appointmentNotes ?? "None",
      "total_weight": _calculateTotalWeight(appointment.wasteMaterials).toString(),
    };

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailsPage(appointment: appointmentMap),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isPickup
                  ? [Colors.grey[200]!, Colors.grey[300]!]
                  : [const Color(0xFFCDD6AA), const Color(0xFFB1BC83)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDateTime(appointment.appointmentDate),
                style: const TextStyle(
                  fontFamily: 'Mallanna',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "at ${appointment.appointmentLocation}",
                style: const TextStyle(
                  fontFamily: 'Mallanna',
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusChip(appointment.appointmentStatus),
                  _buildTypeChip(appointment.appointmentType),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Waste Details: ${_formatWasteDetails(appointment.wasteMaterials)}",
                style: const TextStyle(fontFamily: 'Mallanna', fontSize: 14),
              ),
              if (isPickup) ...[
                const SizedBox(height: 5),
                ServiceNameLabel(serviceId: appointment.serviceId, isPickup: isPickup),
              ],
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalWeight(List<AppointmentWaste> materials) =>
      materials.fold(0.0, (sum, m) => sum + (m.weightKg ?? 0));

  String _formatDateTime(DateTime date) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minutes = date.minute.toString().padLeft(2, '0');
    final year = date.year != DateTime.now().year ? " ${date.year}" : "";
    return "${date.day} ${months[date.month - 1]}$year at $hour:$minutes $amPm";
  }

  String _formatStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending: return "Pending";
      case AppointmentStatus.confirmed: return "Confirmed";
      case AppointmentStatus.completed: return "Completed";
      case AppointmentStatus.cancelled: return "Cancelled";
    }
  }

  String _formatWasteDetails(List<AppointmentWaste> materials) {
    if (materials.isEmpty) return "No materials";
    if (materials.length == 1) return "1 item";
    return "${materials.length} items";
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color color;
    switch (status) {
      case AppointmentStatus.pending: color = Colors.orange; break;
      case AppointmentStatus.confirmed: color = Colors.green; break;
      case AppointmentStatus.completed: color = Colors.blue; break;
      case AppointmentStatus.cancelled: color = Colors.red; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(_formatStatus(status),
          style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Mallanna')),
    );
  }

  Widget _buildTypeChip(AppointmentType type) {
    final isPickup = type == AppointmentType.pickUp;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPickup ? Colors.black45 : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPickup ? "Pick-Up" : "Drop-Off",
        style: TextStyle(
          color: isPickup ? Colors.white : Colors.black87,
          fontSize: 12,
          fontFamily: 'Mallanna',
        ),
      ),
    );
  }
}

class ServiceNameLabel extends ConsumerWidget {
  final String serviceId;
  final bool isPickup;
  const ServiceNameLabel({super.key, required this.serviceId, required this.isPickup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(disposalServiceByIdProvider(serviceId));
    return serviceAsync.when(
      data: (service) {
        if (!isPickup || service == null) return const SizedBox.shrink();
        return Row(
          children: [
            const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF4B5320)),
            const SizedBox(width: 5),
            Text(
              "To be picked up by ${service.serviceName}",
              style: const TextStyle(
                fontFamily: 'Mallanna',
                fontSize: 14,
                color: Color(0xFF4B5320),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}
