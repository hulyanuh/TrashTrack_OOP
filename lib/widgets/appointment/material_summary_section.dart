import 'package:flutter/material.dart';
import '../info_section.dart';

class MaterialSummarySection extends StatelessWidget {
  final Map<String, Map<String, dynamic>> materialSummary;
  final String notes;

  const MaterialSummarySection({
    super.key,
    required this.materialSummary,
    required this.notes,
  });

    @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoSection(
          title: "Waste Information",
          children: [
            const Text(
              "Materials",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B5320),
                fontFamily: 'Mallanna',
              ),
            ),
            const SizedBox(height: 12),
            ...materialSummary.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Mallanna',
                      ),
                    ),
                    Text(
                      "${entry.value['weight'].toStringAsFixed(2)} kg",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mallanna',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 24),
        if (notes.isNotEmpty)
          InfoSection(
            title: "Notes",
            children: [
              Text(
                notes,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Mallanna',
                ),
              ),
            ],
          ),
      ],
    );
  }

}
