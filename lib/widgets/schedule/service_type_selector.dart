import 'package:flutter/material.dart';
import '../../models/disposal_service.dart';
import '../../models/appointment_model.dart';

class ServiceTypeSelector extends StatelessWidget {
  final DisposalService service;
  final AppointmentType? selectedType;
  final Function(AppointmentType) onTypeSelected;

  const ServiceTypeSelector({
    Key? key,
    required this.service,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If service only offers one type, show text instead of buttons
    if (service.serviceAvailability.length == 1) {
      String serviceType = service.serviceAvailability.first;
      AppointmentType type = serviceType == 'Pick-Up'
          ? AppointmentType.pickUp
          : AppointmentType.dropOff;

      // Auto-select the only available type
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onTypeSelected(type);
      });

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          "Service Type: $serviceType",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    // If service offers both types, show buttons
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Service",
          style: TextStyle(fontSize: 22,fontFamily: 'Mallana', fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text("Please select a type of service"),
        const SizedBox(height: 10),
        Row(
          children: [
            if (service.serviceAvailability.contains('Pick-Up'))
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedType == AppointmentType.pickUp
                        ? const Color(0xFF4B5320)
                        : Colors.grey[300],
                    foregroundColor: selectedType == AppointmentType.pickUp
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () => onTypeSelected(AppointmentType.pickUp),
                  child: const Text("Pick up"),
                ),
              ),
            if (service.serviceAvailability.contains('Pick-Up') &&
                service.serviceAvailability.contains('Drop-Off'))
              const SizedBox(width: 10),
            if (service.serviceAvailability.contains('Drop-Off'))
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedType == AppointmentType.dropOff
                        ? const Color(0xFF4B5320)
                        : Colors.grey[300],
                    foregroundColor: selectedType == AppointmentType.dropOff
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () => onTypeSelected(AppointmentType.dropOff),
                  child: const Text("Drop off"),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
