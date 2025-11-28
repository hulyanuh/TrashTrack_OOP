// widgets/dropoff_details_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/disposal_service.dart';
// import '../../models/available_schedule.dart';
import '../../models/operating_hours.dart';

class DropoffDetailsSection extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final DisposalService service;

  const DropoffDetailsSection({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.service,
  });

  bool _isWithinOperatingHours(DateTime dateTime) {
    // In ISO format, Monday is 1 and Sunday is 7
    final dayOfWeek = dateTime.weekday; // 1 = Monday, 7 = Sunday

    // Find operating hours for this day
    final operatingDay = service.operatingHours.firstWhere(
      (h) => h.operatingDays == dayOfWeek && h.isOpen,
      orElse: () => OperatingHours(
        operatingId: '0',
        serviceId: '0',
        operatingDays: dayOfWeek,
        openTime: '00:00',
        closeTime: '00:00',
        isOpen: false,
      ),
    );

    if (!operatingDay.isOpen) {
      return false;
    }

    // Parse the time in 24-hour format (HH:mm)
    final startParts = operatingDay.openTime.split(":");
    final endParts = operatingDay.closeTime.split(":");

    final startTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );
    final endTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    // Check if selected time is within the operating hours
    return dateTime.isAfter(startTime) && dateTime.isBefore(endTime);
  }

  String _formatReadableDate(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy, h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Drop Off Details",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Mallanna',
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Date & Time",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Mallanna'),
        ),
        const SizedBox(height: 10),
        // Date & Time Picker
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () async {
              // Get current operating hours for validation
              final currentDay = DateTime.now().weekday;
              final todayHours = service.operatingHours.firstWhere(
                (h) => h.operatingDays == currentDay,
                orElse: () => service.operatingHours.first,
              );

              final initialTime = TimeOfDay(
                hour: int.parse(todayHours.openTime.split(':')[0]),
                minute: int.parse(todayHours.openTime.split(':')[1]),
              );

              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                selectableDayPredicate: (DateTime date) {
                  // Only allow days that have operating hours
                  return service.operatingHours.any(
                    (oh) => oh.operatingDays == date.weekday && oh.isOpen,
                  );
                },
              );

              if (pickedDate != null) {
                final dayHours = service.operatingHours.firstWhere(
                  (h) => h.operatingDays == pickedDate.weekday && h.isOpen,
                  orElse: () => todayHours,
                );

                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedDate),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(alwaysUse24HourFormat: false),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  final newDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  if (_isWithinOperatingHours(newDateTime)) {
                    onDateSelected(newDateTime);
                  } else {
                    final formattedHours = dayHours.formattedHours;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select a time within operating hours ($formattedHours)',
                          style: const TextStyle(fontFamily: 'Mallanna'),
                        ),
                      ),
                    );
                  }
                }
              }
            },
            title: Text(
              _formatReadableDate(selectedDate),
              style: const TextStyle(
                color: Colors.black87,
                fontFamily: 'Mallanna',
              ),
            ),
            trailing: const Icon(
              Icons.calendar_today,
              color: Color(0xFF4B5320),
            ),
          ),
        ),
      ],
    );
  }
}
