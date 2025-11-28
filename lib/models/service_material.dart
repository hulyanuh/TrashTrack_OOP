import 'material_points.dart';

class ServiceMaterial {
  final String serviceMaterialsId;
  final String disposalServiceId;
  final String materialPointsId;
  final MaterialPoints materialPoints;

  ServiceMaterial({
    required this.serviceMaterialsId,
    required this.disposalServiceId,
    required this.materialPointsId,
    required this.materialPoints,
  });

  factory ServiceMaterial.fromMap(Map<String, dynamic> map) {
    try {
      print('Converting map to ServiceMaterial: $map'); // Debug log
      return ServiceMaterial(
        serviceMaterialsId: map['service_materials_id'] as String,
        disposalServiceId: map['disposal_service_id'] as String,
        materialPointsId: map['material_points_id'] as String,
        materialPoints: MaterialPoints.fromMap(
          map['material_points'] as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      print('Error creating ServiceMaterial from map: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() => {
    'service_materials_id': serviceMaterialsId,
    'disposal_service_id': disposalServiceId,
    'material_points_id': materialPointsId,
    'material_points': materialPoints.toMap(),
  };
}
