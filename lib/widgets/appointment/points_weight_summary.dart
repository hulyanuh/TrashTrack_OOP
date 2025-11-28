import 'package:flutter/material.dart';

class PointsWeightSummary extends StatelessWidget {
  final double totalPoints;
  final double totalWeight;

  const PointsWeightSummary({
    super.key,
    required this.totalPoints,
    required this.totalWeight,
  });

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4B5320)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B5320),
            fontFamily: 'Mallanna',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Mallanna',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            Icons.star_outline,
            "${totalPoints.toStringAsFixed(0)} pts",
            "Total Points",
          ),
          _buildSummaryItem(
            Icons.scale_outlined,
            "${totalWeight.toStringAsFixed(2)} kg",
            "Total Weight",
          ),
        ],
      ),
    );
  }
}
