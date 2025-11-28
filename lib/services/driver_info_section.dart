import 'package:flutter/material.dart';
import '../widgets/info_section.dart';

class DriverInfoSection extends StatelessWidget {
  final String? driverName;
  final String? driverNumber;
  final bool useMockData;

  const DriverInfoSection({
    super.key,
    this.driverName,
    this.driverNumber,
    this.useMockData = false,
  });

  // Mock data
  static const mockDrivers = [
    {'name': 'Juan Dela Cruz', 'contact': '+63 912 345 6789'},
    {'name': 'Maria Santos', 'contact': '+63 923 456 7890'},
    {'name': 'Pedro Reyes', 'contact': '+63 934 567 8901'},
  ];

  String get _getDriverName {
    if (useMockData) {
      // Randomly select a mock driver when no specific driver is assigned
      final mockDriver =
          mockDrivers[DateTime.now().microsecond % mockDrivers.length];
      return mockDriver['name']!;
    }
    return driverName ?? "Not assigned";
  }

  String get _getDriverContact {
    if (useMockData) {
      final mockDriver = mockDrivers[DateTime.now().microsecond % mockDrivers.length];
      return mockDriver['contact']!;
    }
    return driverNumber ?? "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: "Driver Information",
      children: [
        InfoRow(label: "Name", content: _getDriverName),
        InfoRow(label: "Contact", content: _getDriverContact),
      ],
    );
  }
}
