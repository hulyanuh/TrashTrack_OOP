import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/disposal_service.dart';
import '../repositories/disposal_service_repository.dart';

// Repository provider
final disposalServiceRepositoryProvider = Provider<DisposalServiceRepository>((
  ref,
) {
  return DisposalServiceRepository();
});

// Disposal service by ID provider
final disposalServiceByIdProvider =
    FutureProvider.family<DisposalService?, String>((ref, serviceId) async {
      final repo = ref.watch(disposalServiceRepositoryProvider);
      return await repo.getDisposalServiceById(serviceId);
    });

// All services provider
final allServicesProvider = FutureProvider<List<DisposalService>>((ref) async {
  final repository = ref.watch(disposalServiceRepositoryProvider);
  return repository.getAllServices();
});

// Recommended services provider (limited to 2 for dashboard)
final dashboardRecommendedServicesProvider =
    FutureProvider<List<DisposalService>>((ref) async {
      try {
        final repository = ref.watch(disposalServiceRepositoryProvider);
        print('Fetching recommended services from provider...');
        final services = await repository.getRecommendedServices();
        print('Got ${services.length} recommended services');
        if (services.isEmpty) {
          print('Warning: No recommended services returned from repository');
        }
        return services.take(2).toList();
      } catch (e, stack) {
        print('Error in recommended services provider: $e');
        print('Stack trace: $stack');
        rethrow;
      }
    });

// Top services provider (limited to 2 for dashboard)
final dashboardTopServicesProvider = FutureProvider<List<DisposalService>>((
  ref,
) async {
  try {
    final repository = ref.watch(disposalServiceRepositoryProvider);
    print('Fetching top services from provider...');
    final services = await repository.getTopServices();
    print('Got ${services.length} top services');
    if (services.isEmpty) {
      print('Warning: No top services returned from repository');
    }
    return services.take(2).toList();
  } catch (e, stack) {
    print('Error in top services provider: $e');
    print('Stack trace: $stack');
    rethrow;
  }
});

// Recommended services provider (no limit)
final recommendedServicesProvider = FutureProvider<List<DisposalService>>((
  ref,
) async {
  try {
    final repository = ref.watch(disposalServiceRepositoryProvider);
    return repository.getRecommendedServices();
  } catch (e, stack) {
    print('Error in all recommended services provider: $e');
    print('Stack trace: $stack');
    rethrow;
  }
});

// Top services provider (no limit)
final topServicesProvider = FutureProvider<List<DisposalService>>((ref) async {
  try {
    final repository = ref.watch(disposalServiceRepositoryProvider);
    return repository.getTopServices();
  } catch (e, stack) {
    print('Error in all top services provider: $e');
    print('Stack trace: $stack');
    rethrow;
  }
});

// Provider for all available material types
final materialTypesProvider = FutureProvider<List<String>>((ref) async {
  try {
    final repository = ref.watch(disposalServiceRepositoryProvider);
    final materials = await repository.getMaterialTypes();
    return materials;
  } catch (e, stack) {
    print('Error fetching material types: $e');
    print('Stack trace: $stack');
    rethrow;
  }
});

// Search services provider
final searchServicesProvider =
    FutureProvider.family<List<DisposalService>, SearchParams>((
      ref,
      params,
    ) async {
      try {
        final repository = ref.watch(disposalServiceRepositoryProvider);
        final services = await repository.searchServices(
          query: params.query,
          materialType: params.materialType,
          isOpen: params.isOpen,
        );
        return services;
      } catch (e, stack) {
        print('Error in search services provider: $e');
        print('Stack trace: $stack');
        rethrow;
      }
    });

// Helper provider to check if a service is currently open
final isServiceOpenProvider = Provider.family<bool, DisposalService>((
  ref,
  service,
) {
  final now = DateTime.now();
  final currentDay = now.weekday;

  // Check if there are any operating hours for today
  final todayHoursExists = service.operatingHours.any(
    (hours) => hours.operatingDays == currentDay,
  );

  // If no hours exist for today, the service is closed
  if (!todayHoursExists) {
    print('Service ${service.serviceName} is closed (no hours for today)');
    return false;
  }

  // Find today's operating hours
  final todayHours = service.operatingHours.firstWhere(
    (hours) => hours.operatingDays == currentDay,
  );

  // Check if explicitly marked as closed
  if (!todayHours.isOpen) {
    print('Service ${service.serviceName} is marked as closed today');
    return false;
  }

  // Parse opening and closing times
  final openingTime = _parseTimeString(todayHours.openTime);
  final closingTime = _parseTimeString(todayHours.closeTime);
  final currentTime = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
    now.minute,
  );

  return currentTime.isAfter(openingTime) && currentTime.isBefore(closingTime);
});

// Helper function to parse time string (HH:mm) to DateTime
DateTime _parseTimeString(String timeStr) {
  final now = DateTime.now();
  final parts = timeStr.split(':');
  return DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}


// Search parameters class
class SearchParams {
  final String query;
  final String? materialType;
  final bool? isOpen;

  const SearchParams({required this.query, this.materialType, this.isOpen});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchParams &&
        other.query == query &&
        other.materialType == materialType &&
        other.isOpen == isOpen;
  }

  @override
  int get hashCode => Object.hash(query, materialType, isOpen);
}
