import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/appointments_page.dart';
import '../screens/bookmark_screen.dart';
import '../screens/notification_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24), // Top corners only
        ),
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
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () {
              onTap(index);
              switch (index) {
                case 0: // Home
                  if (currentIndex != 0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  }
                  break;
                case 1: // Collections
                  if (currentIndex != 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CollectionsPage(),
                      ),
                    );
                  }
                  break;
                case 2: // Appointment Page
                  if (currentIndex != 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppointmentsPage(),
                      ),
                    );
                  }
                  break;
                case 3: // Notifications
                  if (currentIndex != 3) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  }
                  break;
                case 4: // Collections
                  if (currentIndex != 4) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  }
                  break;
                // Add other cases for appointments, notifications, settings when needed
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4A5F44).withValues(alpha:  0.1)
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
    );
  }
}

// 🧩 Swap in your actual image asset paths here
final List<Map<String, String>> _navIcons = [
  {
    'default': 'assets/icons/home.png',
    'active': 'assets/icons/home_active.png',
  },
  {
    'default': 'assets/icons/collections.png',
    'active': 'assets/icons/collections_active.png',
  },
  {
    'default': 'assets/icons/appointments.png',
    'active': 'assets/icons/appointments_active.png',
  },
  {
    'default': 'assets/icons/notifications.png',
    'active': 'assets/icons/notifications_active.png',
  },
  {
    'default': 'assets/icons/settings.png',
    'active': 'assets/icons/settings_active.png',
  },
];
