import 'package:flutter/material.dart';
import '../info_section.dart';

class LocationDetailsSection extends StatelessWidget {
  final String address;
  final String? phoneNumber;
  final bool isPickup;

  const LocationDetailsSection({
    super.key,
    required this.address,
    this.phoneNumber,
    required this.isPickup,
  });

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: "Location Details",
      children: [
        InfoRow(label: "Address", content: address),
        if (isPickup && phoneNumber != null)
          InfoRow(label: "Contact", content: phoneNumber!),
      ],
    );
  }
}
