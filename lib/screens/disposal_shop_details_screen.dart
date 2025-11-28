import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/disposal_service.dart';
import '../providers/disposal_service_provider.dart';
import '../providers/favorite_services_provider.dart';
import 'schedule_appointment_page.dart';

class DisposalShopDetailsScreen extends ConsumerStatefulWidget {
  final DisposalService service;

  const DisposalShopDetailsScreen({super.key, required this.service});

  @override
  ConsumerState<DisposalShopDetailsScreen> createState() =>
      _DisposalShopDetailsScreenState();
}

class _DisposalShopDetailsScreenState
    extends ConsumerState<DisposalShopDetailsScreen> {
  String _formatOperatingHours() {
    final now = DateTime.now();
    final currentDay = now.weekday;

    final todayHours = widget.service.operatingHours
        .where((hours) => hours.operatingDays == currentDay)
        .firstOrNull;

    if (todayHours == null) return 'Closed Today';
    if (!todayHours.isOpen) return 'Closed Today';

    final openFormat = DateFormat('HH:mm');
    final displayFormat = DateFormat('h:mm a');

    final openTime = openFormat.parse(todayHours.openTime);
    final closeTime = openFormat.parse(todayHours.closeTime);

    return '${todayHours.dayName}, ${displayFormat.format(openTime)} - ${displayFormat.format(closeTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'You must be logged in to view this page.',
            style: TextStyle(fontSize: 16, fontFamily: 'Mallanna'),
          ),
        ),
      );
    }

    final userId = user.id;
    final favoriteServices = ref.watch(favoriteServicesProvider(userId));
    final isFavorited = favoriteServices.contains(widget.service.serviceId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Image.network(
                      widget.service.serviceImgUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          width: double.infinity,
                          color: const Color(0xFFD9D9D9),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: 24,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Shop name and collections icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.service.serviceName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mallanna',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .read(favoriteServicesProvider(userId).notifier)
                          .toggleFavorite(widget.service.serviceId);
                    },
                    child: Image.asset(
                      isFavorited
                          ? 'assets/icons/collections_active.png'
                          : 'assets/icons/collections.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Operating Hours
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: ref.watch(isServiceOpenProvider(widget.service))
                        ? const Color(0xFF6A8126)
                        : Colors.red[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatOperatingHours(),
                    style: TextStyle(
                      fontSize: 14,
                      color: ref.watch(isServiceOpenProvider(widget.service))
                          ? const Color(0xFF6A8126)
                          : Colors.red[400],
                      fontFamily: 'Mallanna',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.service.serviceLocation,
                      style: const TextStyle(
                        fontFamily: 'Mallanna',
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Availability
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    size: 16,
                    color: Color(0xFF6A8126),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.service.serviceAvailability.join(", "),
                      style: const TextStyle(
                        fontFamily: 'Mallanna',
                        color: Color(0xFF6A8126),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Materials Accepted
              const Text(
                'Materials Accepted',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mallanna',
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.service.serviceMaterials
                    .map((sm) => sm.materialPoints.materialType)
                    .toSet()
                    .map((materialType) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A5F44).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF4A5F44),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          materialType,
                          style: const TextStyle(
                            color: Color(0xFF4A5F44),
                            fontSize: 14,
                            fontFamily: 'Mallanna',
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),

              const SizedBox(height: 16),

              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mallanna',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.service.serviceDescription,
                style: const TextStyle(fontFamily: 'Mallanna'),
              ),

              const SizedBox(height: 24),

              // Schedule Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ScheduleAppointmentPage(service: widget.service),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A5F44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Schedule',
                    style: TextStyle(
                      fontFamily: 'Mallanna',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
