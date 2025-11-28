import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trash_track/screens/eco_shop_screen.dart';
import 'package:trash_track/screens/scan_screen.dart';
import 'disposal_shop_details_screen.dart';
import '../providers/disposal_service_provider.dart';
import '../providers/favorite_services_provider.dart';
import '../widgets/disposal_service_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'search_screen.dart';
import 'top_services_screen.dart';
import 'recommended_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'You must be logged in to view the dashboard.',
            style: TextStyle(fontSize: 16, fontFamily: 'Mallanna'),
          ),
        ),
      );
    }

    final userId = user.id;
    final recommendedServices = ref.watch(dashboardRecommendedServicesProvider);
    final topServices = ref.watch(dashboardTopServicesProvider);
    final favoriteIds = ref.watch(favoriteServicesProvider(userId));
    final favoritesNotifier = ref.read(
      favoriteServicesProvider(userId).notifier,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 220,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF4A5F44),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 260,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 20,
                                top: 0,
                                child: Opacity(
                                  opacity: 1,
                                  child: Image.asset(
                                    'assets/images/World-cuate 1.png',
                                    height: 280,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Save The Planet',
                                              style: TextStyle(
                                                fontFamily: 'Mallanna',
                                                fontSize: 33,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFEFAE0),
                                              ),
                                            ),
                                            Text(
                                              'Look for recycling sites and\nrecycle for a change',
                                              style: TextStyle(
                                                fontFamily: 'Mallanna',
                                                fontSize: 16,
                                                color: Color(0xFFFEFAE0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => EcoShopScreen()),
                                            );
                                          },
                                          child: Column(
                                            children: const [
                                              Icon(
                                                Icons.shopping_cart,
                                                color: Color(0xFFFEFAE0),
                                                size: 28,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Shop',
                                                style: TextStyle(
                                                  fontFamily: 'Mallanna',
                                                  color: Color(0xFFFEFAE0),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SearchScreen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 52,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD9D9D9),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.search,
                                                  color: Color(0xFF4A5F44),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Search',
                                                    style: TextStyle(
                                                      fontFamily: 'Mallanna',
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          // Navigate to ScanScreen on tap
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ScanScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 52,
                                          height: 52,
                                          padding: const EdgeInsets.all(13),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD9D9D9),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/images/qr_code.png',
                                            color: const Color(0xFF4A5F44),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Recommended
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recommended',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mallanna',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  const RecommendedScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Color(0xFF4A5F44),
                                    fontFamily: 'Mallanna',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          recommendedServices.when(
                            data: (services) {
                              if (services.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No recommended services available',
                                    style: TextStyle(
                                      fontFamily: 'Mallanna',
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }
                              return Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: services.map((service) {
                                    return DisposalServiceCard(
                                      service: service,
                                      isFavorite: favoriteIds.contains(
                                        service.serviceId,
                                      ),
                                      onFavorite: () => favoritesNotifier
                                          .toggleFavorite(service.serviceId),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DisposalShopDetailsScreen(
                                                  service: service,
                                                ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF4A5F44),
                              ),
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
                          const SizedBox(height: 32),

                          // Top Services
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Top Services',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Mallanna',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TopServicesScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Color(0xFF4A5F44),
                                    fontFamily: 'Mallanna',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          topServices.when(
                            data: (services) {
                              if (services.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No top services available',
                                    style: TextStyle(
                                      fontFamily: 'Mallanna',
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }
                              return Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: services.map((service) {
                                    return DisposalServiceCard(
                                      service: service,
                                      isFavorite: favoriteIds.contains(
                                        service.serviceId,
                                      ),
                                      onFavorite: () => favoritesNotifier
                                          .toggleFavorite(service.serviceId),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DisposalShopDetailsScreen(
                                                  service: service,
                                                ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF4A5F44),
                              ),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
