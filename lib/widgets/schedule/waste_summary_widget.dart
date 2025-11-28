import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../models/appointment_waste.dart';
import '../../models/disposal_service.dart';
import '../../models/available_schedule.dart';

class WasteSummaryWidget extends StatelessWidget {
  final List<AppointmentWaste> wasteMaterials;
  final DisposalService service;
  final AppointmentType? selectedType;
  final String? userLocation;
  final AvailableSchedule? selectedSchedule;
  final DateTime selectedDate;

  const WasteSummaryWidget({
    super.key,
    required this.wasteMaterials,
    required this.service,
    required this.selectedType,
    this.userLocation,
    this.selectedSchedule,
    required this.selectedDate,
  });

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(String time24) {
    final parts = time24.split(":").map(int.parse).toList();
    final hour = parts[0];
    final minute = parts[1];
    final period = hour >= 12 ? "PM" : "AM";
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    return "$hour12:$minuteStr $period";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Waste Summary",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Mallanna',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Below is a summary of your entered waste information. You can update or edit it above.",
          style: TextStyle(fontFamily: 'Mallanna', color: Colors.black54),
        ),
        const SizedBox(height: 10),
        if (wasteMaterials.isNotEmpty) ...[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mallanna',
                ),
              ),
              Text(
                "Weight",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mallanna',
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ...wasteMaterials.map((waste) {
            final material = service.serviceMaterials.firstWhere(
              (m) => m.serviceMaterialsId == waste.serviceMaterialId,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    material.materialPoints.materialType,
                    style: const TextStyle(fontFamily: 'Mallanna'),
                  ),
                  Text(
                    '${waste.weightKg} kg',
                    style: const TextStyle(fontFamily: 'Mallanna'),
                  ),
                ],
              ),
            );
          }),
        ],
        const SizedBox(height: 10),
        if (selectedType == AppointmentType.pickUp && userLocation != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address: $userLocation",
                style: const TextStyle(fontFamily: 'Mallanna'),
              ),
              if (selectedSchedule != null)
                Text(
                  "Pick Up Date: ${_formatDate(selectedSchedule!.availDate)}\n"
                      "Time: ${_formatTime(selectedSchedule!.availStartTime)} - ${_formatTime(selectedSchedule!.availEndTime)}",
                  style: const TextStyle(fontFamily: 'Mallanna'),
                ),
            ],
          ),
        if (selectedType == AppointmentType.dropOff)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Drop-off Location: ${service.serviceLocation}",
                style: const TextStyle(fontFamily: 'Mallanna'),
              ),
              Text(
                "Drop-off Date: ${selectedDate.toString().split('.')[0]}",
                style: const TextStyle(fontFamily: 'Mallanna'),
              ),
            ],
          ),
      ],
    );
  }
}
