import 'package:flutter/material.dart';
import 'operating_hours.dart';
import 'service_material.dart';
import 'appointment_model.dart';

class DisposalService {
  final String serviceId; // Unique identifier for the service
  final String serviceName;
  final String serviceDescription;
  final String serviceLocation;
  final double serviceDistance;
  final double serviceRating;
  final String serviceImgUrl;
  final List<String> serviceAvailability;
  final List<ServiceMaterial> serviceMaterials;
  final bool isRecommended;
  final List<OperatingHours> operatingHours;

  DisposalService({
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceLocation,
    required this.serviceDistance,
    required this.serviceRating,
    required this.serviceImgUrl,
    required this.serviceAvailability,
    required this.serviceMaterials,
    required this.isRecommended,
    this.operatingHours = const [],
  });

  // Convert Supabase Map to DisposalService object
  factory DisposalService.fromMap(Map<String, dynamic> map) {
    print('Converting map to DisposalService: $map'); // Debug log

    try {
      return DisposalService(
        serviceId: map['service_id']?.toString() ?? '',
        serviceName: map['service_name']?.toString() ?? '',
        serviceDescription: map['service_description']?.toString() ?? '',
        serviceLocation: map['service_location']?.toString() ?? '',
        serviceDistance: (map['service_distance'] as num?)?.toDouble() ?? 0.0,
        serviceRating: (map['service_rating'] as num?)?.toDouble() ?? 0.0,
        serviceImgUrl: map['service_img']?.toString() ?? '',
        serviceAvailability:
            (map['service_avail'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        isRecommended: map['is_recommended'] as bool? ?? false,
        operatingHours:
            (map['operating_hours'] as List<dynamic>?)
                ?.map((e) => OperatingHours.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
        serviceMaterials:
            (map['service_materials'] as List<dynamic>?)
                ?.map((e) => ServiceMaterial.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error creating DisposalService from map: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'service_description': serviceDescription,
      'service_location': serviceLocation,
      'service_distance': serviceDistance,
      'service_rating': serviceRating,
      'service_img': serviceImgUrl,
      'service_avail': serviceAvailability,
      'is_recommended': isRecommended,
      'operating_hours': operatingHours.map((e) => e.toMap()).toList(),
      'service_materials': serviceMaterials.map((e) => e.toMap()).toList(),
    };
  }

  // Helper methods for UI
  String get formattedDistance => '${serviceDistance.toStringAsFixed(1)}km';

  Widget get formattedRating => Row(
    children: [
      Text(serviceRating.toStringAsFixed(1)),
      const Icon(Icons.star, color: Colors.amber, size: 16),
    ],
  );

  bool isCurrentlyOpen() {
    if (operatingHours.isEmpty) return false;

    // Get current day of week (1 = Monday, 7 = Sunday)
    final now = DateTime.now();
    int currentDay = now.weekday;

    // Find operating hours for current day
    final todayHours = operatingHours.where(
      (hour) => hour.operatingDays == currentDay,
    );
    if (todayHours.isEmpty) return false;

    // Parse current time and opening/closing times
    final currentTime = TimeOfDay.fromDateTime(now);

    for (var hours in todayHours) {
      try {
        final openTime = _parseTime(hours.openTime);
        final closeTime = _parseTime(hours.closeTime);

        if (_isTimeBetween(currentTime, openTime, closeTime)) {
          return true;
        }
      } catch (e) {
        print('Error parsing operating hours: $e');
        continue;
      }
    }

    return false;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool _isTimeBetween(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final now = time.hour * 60 + time.minute;
    final open = start.hour * 60 + start.minute;
    final close = end.hour * 60 + end.minute;

    if (close < open) {
      // Handles cases where service closes after midnight
      return now >= open || now <= close;
    }
    return now >= open && now <= close;
  }

  // Helper methods to check service availability
  bool get hasPickupService => serviceAvailability.contains('Pick-Up');
  bool get hasDropoffService => serviceAvailability.contains('Drop-Off');
  bool get hasBothServices => hasPickupService && hasDropoffService;

  AppointmentType? get defaultServiceType {
    if (serviceAvailability.length == 1) {
      if (hasPickupService) return AppointmentType.pickUp;
      if (hasDropoffService) return AppointmentType.dropOff;
    }
    return null;
  }
}
