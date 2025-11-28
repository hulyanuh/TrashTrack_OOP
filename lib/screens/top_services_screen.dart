import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/disposal_service.dart';
import '../providers/disposal_service_provider.dart';
import '../providers/favorite_services_provider.dart';
import '../widgets/disposal_service_card.dart';
import '../widgets/filter_bar.dart';
import 'disposal_shop_details_screen.dart';

class TopServicesScreen extends ConsumerStatefulWidget {
  const TopServicesScreen({super.key});

  @override
  ConsumerState<TopServicesScreen> createState() => _TopServicesScreenState();
}

class _TopServicesScreenState extends ConsumerState<TopServicesScreen> {
  String _filterStatus = 'all';

  List<DisposalService> _filterServices(List<DisposalService> services) {
    if (_filterStatus == 'all') return services;

    return services.where((service) {
      final isOpen = ref.watch(isServiceOpenProvider(service));
      return _filterStatus == 'open' ? isOpen : !isOpen;
    }).toList();
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
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
          const SizedBox(height: 24),
          const Text(
            'Top Services',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
              fontFamily: 'Mallanna',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore the highest-rated recycling services worldwide.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.5,
              fontFamily: 'Mallanna',
            ),
          ),
          const SizedBox(height: 24),
          FilterBar(
            selectedFilter: _filterStatus,
            onFilterChanged: (status) => setState(() => _filterStatus = status),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please log in to view your top services.',
            style: TextStyle(fontFamily: 'Mallanna'),
          ),
        ),
      );
    }

    final userId = user.id;
    final topServices = ref.watch(topServicesProvider);
    final favorites = ref.watch(favoriteServicesProvider(userId));
    final favoritesNotifier = ref.read(favoriteServicesProvider(userId).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: topServices.when(
                data: (services) {
                  final filteredServices = _filterServices(services);

                  if (filteredServices.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A5F44).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.stars_rounded,
                              size: 48,
                              color: Color(0xFF4A5F44),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No top services found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'Mallanna',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontFamily: 'Mallanna',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DisposalServiceCard(
                          service: service,
                          isCompact: false,
                          isFavorite: favorites.contains(service.serviceId),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisposalShopDetailsScreen(service: service),
                              ),
                            );
                          },
                          onFavorite: () {
                            favoritesNotifier.toggleFavorite(service.serviceId);
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4A5F44)),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(
                      color: Colors.red,
                      fontFamily: 'Mallanna',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
