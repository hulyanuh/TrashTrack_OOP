import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import '../../models/appointment_waste.dart';

class BottomSummaryWidget extends StatelessWidget {
  final List<AppointmentWaste> wasteMaterials;
  final AppointmentType? selectedType;
  final bool isLoading;
  final VoidCallback onSchedulePressed;

  const BottomSummaryWidget({
    super.key,
    required this.wasteMaterials,
    required this.selectedType,
    required this.isLoading,
    required this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total weight
    double totalWeight = wasteMaterials.fold(
      0,
      (sum, waste) => sum + (waste.weightKg ?? 0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Weight:",
              style: TextStyle(
                fontFamily: 'Mallanna',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${totalWeight.toStringAsFixed(2)} kg',
              style: const TextStyle(fontFamily: 'Mallanna'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedType == AppointmentType.pickUp) ...[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Service Fee:",
                style: TextStyle(
                  fontFamily: 'Mallanna',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('₱50.00'),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ElevatedButton(
          onPressed: isLoading ? null : onSchedulePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B5320),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text(
                  "Schedule",
                  style: TextStyle(
                    fontFamily: 'Mallanna',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
