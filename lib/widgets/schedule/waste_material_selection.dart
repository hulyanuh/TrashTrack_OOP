
import 'package:flutter/material.dart';
import '../../models/appointment_waste.dart';
import '../../models/service_material.dart';

class WasteMaterialSection extends StatelessWidget {
  final List<AppointmentWaste> wasteMaterials;
  final List<ServiceMaterial> serviceMaterials;
  final Function(int index, String newMaterialId) onMaterialChanged;
  final Function(int index, double newWeight) onWeightChanged;
  final Function(int index) onRemove;
  final VoidCallback onAdd;
  final int maxMaterials;

  const WasteMaterialSection({
    super.key,
    required this.wasteMaterials,
    required this.serviceMaterials,
    required this.onMaterialChanged,
    required this.onWeightChanged,
    required this.onRemove,
    required this.onAdd,
    this.maxMaterials = 5,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Waste Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        const Text("Select categories and input waste weight (in kg)."),
        const SizedBox(height: 10),
        ...wasteMaterials.asMap().entries.map((entry) {
          final index = entry.key;
          final waste = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: waste.serviceMaterialId,
                    items: serviceMaterials.map((material) {
                      return DropdownMenuItem(
                        value: material.serviceMaterialsId,
                        child: Text(material.materialPoints.materialType),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) onMaterialChanged(index, val);
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: waste.weightKg?.toString() ?? '1.0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (val) {
                      final weight = double.tryParse(val);
                      if (weight != null) onWeightChanged(index, weight);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Color(0xFFF0F0F0),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      suffixText: 'kg',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () => onRemove(index),
                  iconSize: 20,
                ),
              ],
            ),
          );
        }).toList(),
        Center(
          child: Column(
            children: [
              if (wasteMaterials.length >= maxMaterials)
                const Text(
                  'Maximum 5 materials allowed',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              TextButton.icon(
                onPressed: wasteMaterials.length >= maxMaterials ? null : onAdd,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Material'),
                style: TextButton.styleFrom(foregroundColor: Color(0xFF4B5320)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
