import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/eco_shop_provider.dart';
import 'eco_shop_details.dart';
import 'dashboard_screen.dart';

class EcoShopScreen extends ConsumerStatefulWidget {
  const EcoShopScreen({super.key});

  @override
  ConsumerState<EcoShopScreen> createState() => _EcoShopScreenState();
}

class _EcoShopScreenState extends ConsumerState<EcoShopScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(ecoShopListProvider).fetchShops());
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(ecoShopListProvider);
    final isLoading = provider.isLoading;
    final shops = provider.shops;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background green header
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

            // Main Column
            Column(
              children: [
                SizedBox(
                  height: 260,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        // Recycle image
                        Positioned(
                          right: 20,
                          top: 0,
                          child: Image.asset(
                            'assets/images/eco_shop.png',
                            height: 320,
                          ),
                        ),

                        // Title and subtitle + Shop button
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Shop For Change',
                                        style: TextStyle(
                                          fontFamily: 'Mallanna',
                                          fontSize: 33,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFEFAE0),
                                        ),
                                      ),
                                      Text(
                                        'Look for Eco-friendly shops\nand reduce your waste',
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
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.delete,
                                          color: Color(0xFFFEFAE0),
                                          size: 28,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Recycle',
                                          style: TextStyle(
                                            fontFamily: 'Mallanna',
                                            color: Color(0xFFFEFAE0),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Shops Grid
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1, // Makes cards square
                    ),
                    itemCount: shops.length,
                    itemBuilder: (context, index) {
                      final shop = shops[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShopDetailsScreen(shop: shop),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // Shop Image
                              Positioned.fill(
                                child: Image.network(
                                  shop.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(Icons.storefront),
                                  ),
                                ),
                              ),
                              // Overlay for text contrast
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.6),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Shop Name
                              Positioned(
                                bottom: 12,
                                left: 12,
                                right: 12,
                                child: Text(
                                  shop.shopName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}