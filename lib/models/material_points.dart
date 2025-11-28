class MaterialPoints {
  final String materialPointsId;
  final String materialType; // Type of material (e.g., plastic, paper, etc.)
  final double pointsPerKg;

  MaterialPoints({
    required this.materialPointsId,
    required this.materialType,
    required this.pointsPerKg,
  });

  factory MaterialPoints.fromMap(Map<String, dynamic> map) => MaterialPoints(
    materialPointsId: map['material_points_id'],
    materialType: map['material_type'],
    pointsPerKg: (map['points_per_kg'] as num).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'material_points_id': materialPointsId,
    'material_type': materialType,
    'points_per_kg': pointsPerKg,
  };
}
