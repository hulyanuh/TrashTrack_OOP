import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment_model.dart';
import '../models/appointment_waste.dart';
import '../repositories/appointment_repository.dart'; // Make sure this path matches your file

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final client = Supabase.instance.client;
  return AppointmentRepository(client);
});

/// Creates an appointment along with trash data
final createAppointmentProvider =
    FutureProvider.family<Appointment, Map<String, dynamic>>((
      ref,
      inputData,
    ) async {
      final repo = ref.watch(appointmentRepositoryProvider);
      final Appointment appointment = inputData['appointment'];
      final List<AppointmentWaste> waste = inputData['waste'];
      return await repo.createAppointment(appointment, waste);
    });

/// Finalizes an appointment with QR generation after submission
final finalizeAppointmentProvider = FutureProvider.family<void, String>((
  ref,
  appointmentId,
) async {
  final repo = ref.watch(appointmentRepositoryProvider);
  await repo.finalizeAppointmentWithQr(appointmentId);
});

/// Fetches user’s appointment list
final userAppointmentsProvider = FutureProvider<List<Appointment>>((ref) async {
  final repo = ref.watch(appointmentRepositoryProvider);
  return await repo.getUserAppointments();
});

/// Fetches complete appointment details with all related data
final appointmentDetailsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((
      ref,
      appointmentId,
    ) async {
      final repo = ref.watch(appointmentRepositoryProvider);
      return await repo.getCompleteAppointmentDetails(appointmentId);
    });

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final loginViewModelProvider = Provider((ref) {
  return ref.watch(supabaseClientProvider);
});
