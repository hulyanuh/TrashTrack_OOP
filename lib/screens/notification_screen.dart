import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

// A model class to represent a single notification
class NotificationItem {
  final String title;
  final String message;
  final bool isNew; // Determines the background color
  final String? emoji; // Optional emoji/icon

  NotificationItem({
    required this.title,
    required this.message,
    this.isNew = false,
    this.emoji,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Reminder!',
      message: 'Hey Sam! You have to drop off your...',
      isNew: true, // The latest notification
    ),
    NotificationItem(
      title: 'Badge Unlocked!',
      message: 'Congratulations! You\'ve earned a new...',
    ),
    NotificationItem(
      title: 'First Disposal Success!',
      message: 'Congratulations on your first step...',
    ),
    NotificationItem(
      title: 'Welcome aboard!',
      message: 'Get ready to shop sustainably and...',
      emoji: '🌱',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Main screen title
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 24),
              // "Today" subtitle
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 16),
              // The list of notifications
              Expanded(
                child: ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    // We use the reusable NotificationCard widget here
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: NotificationCard(
                        title: notification.title,
                        message: notification.message,
                        isNew: notification.isNew,
                        emoji: notification.emoji,
                      ),
                    );
                  },
                ),
              ),
              // Placeholder text for the bottom
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    '• No more recent notifications •',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          // Handle navigation based on the index
          // For example, you can use a switch case to navigate to different screen
        },
      ),
    );
  }
}

// A reusable widget to display a single notification card
class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final bool isNew;
  final String? emoji;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    this.isNew = false,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    // Define colors based on whether the notification is new or not
    final Color backgroundColor = isNew ? const Color(0xFFD7E5CA) : const Color(0xFFE0E0E0);
    final Color titleColor = isNew ? const Color(0xFF4F6F52) : const Color(0xFF424242);
    final Color messageColor = isNew ? const Color(0xFF618264) : const Color(0xFF616161);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                // Notification Message
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: messageColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Display emoji if it exists
          if (emoji != null)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                emoji!,
                style: const TextStyle(fontSize: 20),
              ),
            ),
        ],
      ),
    );
  }
}

