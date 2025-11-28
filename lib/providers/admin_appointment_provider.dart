import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment_model.dart';
import '../repositories/admin_appointment_repository.dart';
import '../repositories/appointment_repository.dart';
import 'admin_disposal_provider.dart';

final adminAppointmentRepoProvider = Provider((ref) {
  return AdminAppointmentRepository();
});

// Create an instance of AppointmentRepository for status updates
final appointmentRepoProvider = Provider((ref) {
  return AppointmentRepository(Supabase.instance.client);
});

// Get today's appointments - streamed and auto-refreshed
final adminTodayAppointmentsProvider =
    StreamProvider.autoDispose<List<Appointment>>((ref) async* {
      final repo = ref.read(adminAppointmentRepoProvider);
      final service = await ref.watch(adminServiceProvider.future);

      if (service.serviceId.isEmpty) {
        throw Exception('No service_id found for admin');
      }

      // Set up a periodic refresh
      while (true) {
        try {
          final allAppointments = await repo.getTodayAppointments(
            service.serviceId,
          );

          // Filter to only show pending appointments
          final pendingAppointments = allAppointments
              .where(
                (appointment) =>
                    appointment.appointmentStatus == AppointmentStatus.pending,
              )
              .toList();

          yield pendingAppointments;
        } catch (e) {
          yield [];
        }

        // Refresh every second
        await Future.delayed(const Duration(seconds: 1));
      }
    });

// Get all appointments
final adminAllAppointmentsProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  final repo = ref.read(adminAppointmentRepoProvider);
  final service = await ref.watch(adminServiceProvider.future);

  if (service.serviceId.isEmpty) {
    throw Exception('No service_id found for admin');
  }

  return repo.getAppointmentsByServiceId(serviceId: service.serviceId);
});

// Get completed appointments
final adminCompletedAppointmentsProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  final repo = ref.read(adminAppointmentRepoProvider);
  final service = await ref.watch(adminServiceProvider.future);

  if (service.serviceId.isEmpty) {
    throw Exception('No service_id found for admin');
  }

  return repo.getAppointmentsByServiceId(
    serviceId: service.serviceId,
    status: AppointmentStatus.completed,
  );
});

// Get pending appointments
final adminPendingAppointmentsProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  final repo = ref.read(adminAppointmentRepoProvider);
  final service = await ref.watch(adminServiceProvider.future);

  if (service.serviceId.isEmpty) {
    throw Exception('No service_id found for admin');
  }

  return repo.getAppointmentsByServiceId(
    serviceId: service.serviceId,
    status: AppointmentStatus.pending,
  );
});

// Auto-refreshing pending appointments provider
final adminPendingAppointmentsStreamProvider =
    StreamProvider<List<Appointment>>((ref) async* {
      while (true) {
        final repo = ref.read(adminAppointmentRepoProvider);
        final service = await ref.watch(adminServiceProvider.future);

        if (service.serviceId.isEmpty) {
          throw Exception('No service_id found for admin');
        }

        try {
          final allAppointments = await repo.getAppointmentsByServiceId(
            serviceId: service.serviceId,
          );
          // Filter to only show appointments with pending status
          final pendingAppointments = allAppointments
              .where(
                (appointment) =>
                    appointment.appointmentStatus == AppointmentStatus.pending,
              )
              .toList();
          yield pendingAppointments;
        } catch (e) {
          // If there's an error, yield empty list but don't stop the stream
          yield [];
        }

        // Wait for 3 seconds before next refresh
        await Future.delayed(const Duration(seconds: 3));
      }
    });

// Auto-refreshing completed appointments provider
final adminCompletedAppointmentsStreamProvider =
    StreamProvider<List<Appointment>>((ref) async* {
      while (true) {
        final repo = ref.read(adminAppointmentRepoProvider);
        final service = await ref.watch(adminServiceProvider.future);

        if (service.serviceId.isEmpty) {
          throw Exception('No service_id found for admin');
        }

        try {
          final allAppointments = await repo.getAppointmentsByServiceId(
            serviceId: service.serviceId,
          );
          // Filter to only show appointments with completed status
          final completedAppointments = allAppointments
              .where(
                (appointment) =>
                    appointment.appointmentStatus ==
                    AppointmentStatus.completed,
              )
              .toList();
          yield completedAppointments;
        } catch (e) {
          // If there's an error, yield empty list but don't stop the stream
          yield [];
        }

        // Wait for 3 seconds before next refresh
        await Future.delayed(const Duration(seconds: 3));
      }
    });
