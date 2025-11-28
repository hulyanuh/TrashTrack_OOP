import 'package:flutter/material.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/feedback_screen.dart';

class SuccessfulScanDialog extends StatelessWidget {
  final String message;
  final String appointmentId;

  const SuccessfulScanDialog({
    super.key,
    required this.appointmentId,
    this.message =
        'Your action helps the planet more than you know.\n\nYour points are on the way—check your notifications to claim them!',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
          color: Color(0xFFEEF2E2),
          shape: BoxShape.circle,
          ),
          child: const Icon(
          Icons.check_circle,
          color: Color(0xFF4B5320),
          size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Scan Successful!',
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B5320),
          fontFamily: 'Mallanna',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontFamily: 'Mallanna',
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => DashboardScreen()),
                    (route) => false,
              );
            },
            child: const Text(
            'Close',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Mallanna',
              fontSize: 16,
            ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
            Navigator.pop(context); // Close dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
              builder: (context) => FeedbackScreen(
                appointmentId: appointmentId,
              ),
              ),
            );
            },
            style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B5320),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            ),
            child: const Text(
            'Give Feedback',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Mallanna',
              fontSize: 16,
            ),
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
