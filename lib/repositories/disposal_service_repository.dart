import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/disposal_service.dart';

class DisposalServiceRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Base query with all necessary fields and relationships
  String get _baseQuery => '''
    service_id,
    service_name,
    service_description,
    service_distance,
    service_location,
    service_img,
    service_rating,
    created_at,
    updated_at,
    service_avail,
    is_recommended,
    operating_hours (
      operating_id,
      service_id,
      operating_days,
      open_time,
      close_time,
      is_open
    ),
    available_schedules (
      avail_sched_id,
      service_id,
      avail_date,
      avail_start_time,
      avail_end_time,
      is_slot_booked
    ),
    service_materials (
      service_materials_id,
      disposal_service_id,
      material_points_id,
      material_points (
        material_points_id,
        material_type,
        points_per_kg
      )
    )
  ''';

  // Get all disposal services
  Future<List<DisposalService>> getAllServices() async {
    try {
      final response = await _supabase
          .from('disposal_service')
          .select(_baseQuery);

      return (response as List)
          .map((data) => DisposalService.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch disposal services: $e');
    }
  }

  // Get recommended services
  Future<List<DisposalService>> getRecommendedServices() async {
    try {
      final response = await _supabase
          .from('disposal_service')
          .select(_baseQuery)
          .eq('is_recommended', true)
          .order('service_rating', ascending: false);

      return (response as List)
          .map((data) => DisposalService.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recommended services: $e');
    }
  }

  // Get top rated services
  Future<List<DisposalService>> getTopServices() async {
    try {
      final response = await _supabase
          .from('disposal_service')
          .select(_baseQuery)
          .gt('service_rating', 4.5)
          .order('service_rating', ascending: false);

      return (response as List)
          .map((data) => DisposalService.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top services: $e');
    }
  }

  // Get service by ID
  Future<DisposalService> getServiceById(String id) async {
    try {
      final response = await _supabase
          .from('disposal_service')
          .select(_baseQuery)
          .eq('service_id', id)
          .single();

      return DisposalService.fromMap(response);
    } catch (e) {
      throw Exception('Failed to fetch service: $e');
    }
  }

  // Get disposal service by ID (nullable)
  Future<DisposalService?> getDisposalServiceById(String id) async {
    try {
      final response = await _supabase
          .from('disposal_service')
          .select(_baseQuery)
          .eq('service_id', id)
          .maybeSingle();
      if (response == null) return null;
      return DisposalService.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  // Get all available material types
  Future<List<String>> getMaterialTypes() async {
    try {
      final response = await _supabase
          .from('material_points')
          .select('material_type')
          .order('material_type');

      return (response as List)
          .map((data) => data['material_type'] as String)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch material types: $e');
    }
  }

  // Enhanced search services with filtering by material type and search query
  Future<List<DisposalService>> searchServices({
    required String query,
    String? materialType,
    bool? isOpen,
  }) async {
    try {
      // First, get all services with their materials
      final response = await _supabase
          .from('disposal_service')
          .select(_baseQuery);

      var services = (response as List)
          .map((data) => DisposalService.fromMap(data))
          .toList();

      // Filter by material type if specified
      if (materialType != null) {
        services = services.where((service) {
          return service.serviceMaterials.any(
            (sm) => sm.materialPoints.materialType == materialType,
          );
        }).toList();
      }

      // Filter by search query if provided
      if (query.isNotEmpty) {
        services = services.where((service) {
          return service.serviceName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              service.serviceLocation.toLowerCase().contains(
                query.toLowerCase(),
              );
        }).toList();
      }

      // Sort by rating
      services.sort((a, b) => b.serviceRating.compareTo(a.serviceRating));

      return services;
    } catch (e) {
      throw Exception('Failed to search services: $e');
    }
  }
}
