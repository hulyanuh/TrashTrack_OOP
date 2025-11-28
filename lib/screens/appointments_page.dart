import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash_track/screens/settings_screen.dart';
import '../models/appointment_model.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../providers/appointment_provider.dart';
import '../widgets/appointment/appointment_card.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends ConsumerState<AppointmentsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.refresh(userAppointmentsProvider); // Always refresh on return
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: appointmentsAsync.when(
                data: (appointments) {
                  final now = DateTime.now();
                  final upcoming = appointments
                      .where(
                        (a) =>
                            (a.appointmentStatus == AppointmentStatus.pending ||
                                a.appointmentStatus ==
                                    AppointmentStatus.confirmed) &&
                            !a.appointmentDate.isBefore(DateTime(now.year, now.month, now.day)),
                      )
                      .toList();

                  if (upcoming.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Color(0xFF4B5320),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No upcoming appointments',
                            style: TextStyle(
                              fontFamily: 'Mallanna',
                              fontSize: 18,
                              color: Color(0xFF4B5320),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: upcoming.length,
                    itemBuilder: (context, index) {
                      final appointment = upcoming[index];
                      return AppointmentCard(appointment: appointment);
                    },
                  );
                },

                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4A5F44)),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'Error loading appointments: $error',
                    style: const TextStyle(
                      fontFamily: 'Mallanna',
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (int newIndex) {
          // Already handled in CustomBottomNavBar
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appointments',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                  fontFamily: 'Mallanna',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "History",
                  style: TextStyle(
                    fontFamily: 'Mallanna',
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'View and manage your upcoming appointments here.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
              fontFamily: 'Mallanna',
            ),
          ),
        ],
      ),
    );
  }
}
