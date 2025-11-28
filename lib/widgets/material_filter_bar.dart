import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/disposal_service_provider.dart';

class MaterialFilterBar extends ConsumerWidget {
  final String? selectedMaterial;
  final Function(String?) onMaterialSelected;

  const MaterialFilterBar({
    super.key,
    required this.selectedMaterial,
    required this.onMaterialSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialTypesAsync = ref.watch(materialTypesProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: materialTypesAsync.when(
        data: (materials) {
          final allMaterials = ['All', ...materials];
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allMaterials.map((type) {
              final bool isSelected =
                  type == selectedMaterial ||
                  (type == 'All' && selectedMaterial == null);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: const Color(0xFF4A5F44),
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontFamily: 'Mallanna',
                ),
                onSelected: (bool selected) {
                  if (type == 'All') {
                    onMaterialSelected(null);
                  } else {
                    onMaterialSelected(selected ? type : null);
                  }
                },
              );
            }).toList(),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (e, st) => Text('Error loading materials: $e'),
      ),
    );
  }
}
