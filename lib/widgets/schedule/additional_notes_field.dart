import 'package:flutter/material.dart';

class AdditionalNotesField extends StatelessWidget {
  final TextEditingController controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const AdditionalNotesField({
    super.key,
    required this.controller,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Additional Notes",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Mallanna',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Leave any additional instructions or preferences.",
          style: TextStyle(fontFamily: 'Mallanna', color: Colors.black54),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 2,
          style: const TextStyle(fontFamily: 'Mallanna'),
          decoration: const InputDecoration(
            hintText: "ex. Bags are found at the front of the yard.",
            hintStyle: TextStyle(fontFamily: 'Mallanna', color: Colors.black38),
            filled: true,
            fillColor: Color(0xFFF0F0F0),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
