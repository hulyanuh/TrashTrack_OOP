import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_nav_bar.dart';
import '../widgets/appointment_card.dart';
import '../providers/admin_appointment_provider.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the auto-refreshing stream of pending appointments
    final asyncAppointments = ref.watch(adminTodayAppointmentsProvider);

    return Scaffold(
      bottomNavigationBar: const AdminNavBar(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              height: 240,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF4A5F44),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Opacity(
                      opacity: 1,
                      child: Image.asset(
                        'assets/images/admin_banner.png',
                        height: 280,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 24.0,
                    top: 32.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, admin!',
                          style: TextStyle(
                            fontFamily: 'Mallanna',
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFEFAE0),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Remember, every scan helps\nbuild a cleaner, greener future.',
                          style: TextStyle(
                            fontFamily: 'Mallanna',
                            fontSize: 16,
                            color: Color(0xFFFEFAE0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sticky "Today" header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mallanna',
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Scrollable appointments below
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    asyncAppointments.when(
                      data: (appointments) {
                        if (appointments.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: Center(
                              child: Text(
                                'No pending appointments today.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];
                            final formattedDate = DateFormat(
                              'MMMM d, h:mm a',
                            ).format(appointment.appointmentDate);
                            return AppointmentCard(
                              id: appointment.appointmentInfoId ?? '-',
                              userName:
                                  appointment.userFullName ?? 'Unknown User',
                              datetime: formattedDate,
                              location: appointment.appointmentLocation,
                              status: appointment.appointmentStatus.value,
                            );
                          },
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.only(top: 32.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (err, stack) => Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Center(
                          child: Text(
                            'Error loading appointments: $err',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
