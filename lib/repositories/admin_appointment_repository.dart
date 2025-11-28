import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment_model.dart';

class AdminAppointmentRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get today's appointments for a service
  Future<List<Appointment>> getTodayAppointments(String serviceId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    final response = await _supabase
        .from('appointment_info')
        .select('''
          *,
          user_info:user_info_id (
            user_fname,
            user_lname
          )
        ''')
        .eq('service_id', serviceId)
        .gte('appointment_date', start.toIso8601String())
        .lt('appointment_date', end.toIso8601String())
        .not('appointment_status', 'eq', 'Cancelled') // Still exclude cancelled
        .order('appointment_date');

    return (response as List).map((data) => Appointment.fromMap(data)).toList();
  }

  Future<List<Appointment>> getAppointmentsByServiceId({
    required String serviceId,
    AppointmentStatus? status,
  }) async {
    var query = _supabase
        .from('appointment_info')
        .select('''
        *,
        user_info:user_info_id ( user_fname, user_lname )
      ''')
        .eq('service_id', serviceId);

    if (status != null) {
      final statusValue = status.toString().split('.').last;
      final capitalized =
          statusValue[0].toUpperCase() + statusValue.substring(1);
      query = query.eq('appointment_status', capitalized);
    }

    final result = await query.order('appointment_date', ascending: false);

    return (result as List)
        .map((e) => Appointment.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
