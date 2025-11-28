import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import '../models/disposal_service.dart';
import '../providers/favorite_services_provider.dart';
import '../providers/disposal_service_provider.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/disposal_service_card.dart';
import 'disposal_shop_details_screen.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'You must be logged in to view favorites.',
            style: TextStyle(
              fontFamily: 'Mallanna',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    final userId = user.id;
    final allServices = ref.watch(allServicesProvider);
    final favoriteIds = ref.watch(favoriteServicesProvider(userId));
    final favoritesNotifier = ref.read(favoriteServicesProvider(userId).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // TODO: Navigation
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Collections',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mallanna',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your personal collection of favorite shops!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mallanna',
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Future filter functionality
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Filter',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Mallanna',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: allServices.when(
                  data: (services) {
                    final favoriteServices = services
                        .where((s) => favoriteIds.contains(s.serviceId))
                        .toList();

                    if (favoriteServices.isEmpty) {
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
                              child: Image.asset(
                                'assets/icons/collections.png',
                                width: 48,
                                height: 48,
                                color: const Color(0xFF4A5F44),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No collections yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'Mallanna',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start adding your favorite services',
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

                    return RefreshIndicator(
                      onRefresh: () async {
                        await favoritesNotifier.refreshFavorites();
                      },
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 24,
                        children: favoriteServices.map((service) {
                          return DisposalServiceCard(
                            service: service,
                            isFavorite: true,
                            onFavorite: () => favoritesNotifier.toggleFavorite(service.serviceId),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DisposalShopDetailsScreen(service: service),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
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
      ),
    );
  }
}
