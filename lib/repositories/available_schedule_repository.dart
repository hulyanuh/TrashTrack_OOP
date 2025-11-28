import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/available_schedule.dart';

class AvailableScheduleRepository {
  final SupabaseClient _supabase;

  AvailableScheduleRepository(this._supabase);

  Future<List<AvailableSchedule>> getAvailableSchedules(
    String serviceId,
  ) async {
    try {
      // Get current date without time component for accurate date comparison
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      print('DEBUG: Starting schedule fetch...');
      print('DEBUG: Service ID: $serviceId');
      print('DEBUG: Today\'s date: ${today.toIso8601String()}');

      print('DEBUG: Executing query for service_id: $serviceId');
      final response = await _supabase
          .from('available_schedules')
          .select('*')
          .eq('service_id', serviceId)
          .eq('is_slot_booked', false)
          .gte('avail_date', today.toIso8601String())
          .order('avail_date', ascending: true)
          .order('avail_start_time', ascending: true);
      
      print('DEBUG: Query executed. Response type: ${response.runtimeType}');
      print('DEBUG: Raw query response: $response');

      print('Raw response: $response'); // Debug log

      final schedules = (response as List)
          .map((schedule) => AvailableSchedule.fromMap(schedule))
          .toList();

      print('Parsed schedules: ${schedules.length}'); // Debug log

      return schedules;
    } catch (e) {
      throw Exception('Failed to load available schedules: $e');
    }
  }

  Future<void> bookSchedule(String scheduleId) async {
    try {
      await _supabase
          .from('available_schedules')
          .update({'is_slot_booked': true})
          .eq('avail_sched_id', scheduleId);
    } catch (e) {
      throw Exception('Failed to book schedule: $e');
    }
  }
}
