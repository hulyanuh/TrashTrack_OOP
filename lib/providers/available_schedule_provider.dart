import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/available_schedule.dart';
import '../repositories/available_schedule_repository.dart';

// Repository Provider
final availableScheduleRepositoryProvider = Provider<AvailableScheduleRepository>((ref) {
  return AvailableScheduleRepository(Supabase.instance.client);
});

// FutureProvider.family to get schedules by serviceId
final availableSchedulesProvider = FutureProvider.family<List<AvailableSchedule>, String>((ref, serviceId) async {
  final repo = ref.watch(availableScheduleRepositoryProvider);
  return repo.getAvailableSchedules(serviceId);
});
