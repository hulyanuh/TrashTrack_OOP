import 'package:flutter/material.dart';
import '../screens/admin_dashboard.dart';
import '../screens/admin_history.dart';
import '../screens/admin_shop.dart';
import '../screens/admin_settings.dart';
import '../screens/admin_qr_scan.dart';

class AdminNavBar extends StatelessWidget {
  final int currentIndex;

  const AdminNavBar({super.key, required this.currentIndex});

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHistoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminQRScanScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminShopScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // Adjusted height for navbar
      child: Stack(
        clipBehavior: Clip.none, // Allow button to overflow
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70, // Height of the main navbar
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_navIcons.length, (index) {
                if (index == 2) {
                  return const SizedBox(width: 60); // Leave space for FAB
                }

                final isSelected = index == currentIndex;

                return GestureDetector(
                  onTap: () => _navigate(context, index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4A5F44).withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      isSelected
                          ? _navIcons[index]['active']!
                          : _navIcons[index]['default']!,
                      width: 25,
                      height: 25,
                    ),
                  ),
                );
              }),
            ),
          ),
          // Floating scanner button
          Positioned(
            top: -20, // Position it above the navbar
            child: GestureDetector(
              onTap: () => _navigate(context, 2),
              child: Container(
                height: 80, // Scanner button size
                width: 80, // Scanner button size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4A5F44),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> _navIcons = [
  {
    'default': 'assets/icons/home.png',
    'active': 'assets/icons/home_active.png',
  },
  {
    'default': 'assets/icons/history.png',
    'active': 'assets/icons/history_active.png',
  },
  {}, 
  {
    'default': 'assets/icons/store.png',
    'active': 'assets/icons/store_active.png',
  },
  {
    'default': 'assets/icons/settings.png',
    'active': 'assets/icons/settings_active.png',
  },
];
