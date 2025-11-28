class AppointmentWaste {
  final String? appointmentWasteId;
  final String? appointmentInfoId;
  final double? weightKg;
  final String? serviceMaterialId;

  const AppointmentWaste({
    this.appointmentWasteId,
    this.appointmentInfoId,
    this.weightKg,
    this.serviceMaterialId,
  });

  factory AppointmentWaste.fromMap(Map<String, dynamic> map) {
    return AppointmentWaste(
      appointmentWasteId: map['appointment_waste_id'] ?? '',
      appointmentInfoId: map['appointment_info_id'] ?? '',
      serviceMaterialId: map['service_materials_id'],
      weightKg: (map['weight_kg'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'service_materials_id': serviceMaterialId,
    'weight_kg': weightKg,
  };

}
